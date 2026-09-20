#!/usr/bin/env -S bash -Eeuo pipefail

### General information
# I am returning "ERR" for internal/custom error handling instead of `return 1` due to the fact that the above
# statement, on line 1, which I do want to keep, causes the script to immediately fail on any command error
# This way if it fails silently I will know some command failed, if not, it will have a message by me

###
### Globals
###
# curl splits the authorization header past some length, 16 appears to avoid having to deal with that in the file
HEADERS_FILE_ROUTER='headers_router'
HEADERS_FILE_PORKBUN='headers_porkbun'
DOMAIN_NAME='raquellie.com'

###
### Obtaining the IPs
###
function get_router_addr() {
	local IP_CMD=(ip --json route)
	# Extract the gateway of the default route
	local JQ_CMD=(jq --raw-output '.[] | select(.dst == "default") .gateway')

	"${IP_CMD[@]}" | "${JQ_CMD[@]}"
}

# RouterOS REST API documentation: https://manual.mikrotik.com/docs/developer-guides/rest-api/
function get_router_ipv4() {
	local REQUEST_CMD=(curl --silent --insecure --header "@""$HEADERS_FILE_ROUTER" "$(get_router_addr)"/rest/ip/address)
	# Select the object that contains the correct interface, and extract its address
	local FILTER_CMD=(jq --raw-output '.[] | select(."actual-interface"=="ether8") | ."address"')
	# Cut away the CIDR notation
	local CUT_CMD=(cut --delimiter="/" --fields="1")

	"${REQUEST_CMD[@]}" | "${FILTER_CMD[@]}" | "${CUT_CMD[@]}"
}
function get_router_ipv6() {
	local IP_CMD=(ip -6 --json addr)
	# Extract the global address out of `ip`'s output.
	# Doubly making sure it's not a temporary address. `ip` currently just doesn't give the field if false, but
	# who knows if that'll ever change
	local JQ_CMD=(jq --raw-output '.[].addr_info[] | select(.scope == "global") | select(.temporary | not) | select(.temporary != "true") .local')
	# Ignore Unique Local Addresses
	local AWK_CMD=(awk '/^[^fd00||fc00]/ {print $0}')

	"${IP_CMD[@]}" | "${JQ_CMD[@]}" | "${AWK_CMD[@]}"
}

SERVER_IPV4=$(get_router_ipv4)
SERVER_IPV6=$(get_router_ipv6)

# Triple check this only returns 1 IPv6, I don't intend to interact with this script a lot and who knows if something
# will change or *I* change something that causes the machine to have more than 1 GUA
if [[ $(wc -w <<< "$SERVER_IPV6") > 1 ]]; then
	echo "[ERROR][LOCAL] Got more than 1 IPv6 - review script!" >&2
	exit 1
fi

echo "[INFO][LOCAL] Got IPv4 \"$SERVER_IPV4\" and IPv6 \"$SERVER_IPV6\""

###
### Sending the API requests to the registrar
###
API_BASE_URL='https://api.porkbun.com/api/json/v3'

API_GET_A_RECORD="dns/retrieveByNameType/$DOMAIN_NAME/A"
API_GET_AAAA_RECORD="dns/retrieveByNameType/$DOMAIN_NAME/AAAA"

API_UPDATE_A_RECORD="dns/editByNameType/$DOMAIN_NAME/A"
API_UPDATE_AAAA_RECORD="dns/editByNameType/$DOMAIN_NAME/AAAA"

# (response): full Porkbun response to check
function did_porkbun_error() {
	if [[ $(jq --raw-output '.status' <<< "$1") != "SUCCESS" ]]; then
		echo "ERR"
	fi
}

# (record_type): "A"=>IPv4, "AAAA"=>IPv6
function get_porkbun_record() {
	if [[ "$1" == "A" ]]; then
		local CURL_CMD=(curl --silent --header "@""$HEADERS_FILE_PORKBUN" --request POST "$API_BASE_URL/$API_GET_A_RECORD")
	elif [[ "$1" == "AAAA" ]]; then
		local CURL_CMD=(curl --silent --header "@""$HEADERS_FILE_PORKBUN" --request POST "$API_BASE_URL/$API_GET_AAAA_RECORD")
	fi

	local JQ_CMD=(jq --raw-output '.records.[].content')
	local CURL_RESULT=$("${CURL_CMD[@]}")

	local STATUS=$(did_porkbun_error "$CURL_RESULT")
	if [[ "$STATUS" != "ERR" ]]; then
		echo $("${JQ_CMD[@]}" <<< "$CURL_RESULT")
	else
		echo "ERR"
	fi
}
# (ip_type, new_ip): ip_type ["v4"/"v6"], new_ip (string)
function update_porkbun() {
	# Note: `Content-Type: application/json` is required to be in the header file
	if [[ "$1" == "A" ]]; then
		local CURL_CMD=(curl --silent --header "@""$HEADERS_FILE_PORKBUN" --data '{"content": "'"$2"'"}' --request POST "$API_BASE_URL/$API_UPDATE_A_RECORD")
	elif [[ "$1" == "AAAA" ]]; then
		local CURL_CMD=(curl --silent --header "@""$HEADERS_FILE_PORKBUN" --data '{"content": "'"$2"'"}' --request POST "$API_BASE_URL/$API_UPDATE_AAAA_RECORD")
	fi

	local CURL_RESULT=$("${CURL_CMD[@]}")
	local STATUS=$(did_porkbun_error "$CURL_RESULT")
	if [[ "$STATUS" == "ERR" ]]; then
		echo "ERR"
	fi
}

CURRENT_A_RECORD=$(get_porkbun_record "A")
if [[ "$CURRENT_A_RECORD" == "ERR" ]]; then
	echo "[ERROR][PORKBUN] Failed to retrieve the A record" >&2
	exit 1
fi
CURRENT_AAAA_RECORD=$(get_porkbun_record "AAAA")
if [[ "$CURRENT_AAAA_RECORD" == "ERR" ]]; then
	echo "[ERROR][PORKBUN] Failed to retrieve the A record" >&2
	exit 1
fi

# Currently exiting the script if any (IPv4 since it runs first) of them fails, to make sure I notice the problem faster
if [[ "$SERVER_IPV4" != "$CURRENT_A_RECORD" ]]; then
	echo "[INFO][PORKBUN] Updating A record | From: \"$CURRENT_A_RECORD\" to \"$SERVER_IPV4\""
	STATUS=$(update_porkbun "A" "$SERVER_IPV4")

	if [[ "$STATUS" == "ERR" ]]; then
		echo "[ERROR][PORKBUN] Failed to update the A record" >&2
		exit 1
	fi
else
	echo "[SUCCESS] A record unchanged."
fi

if [[ "$SERVER_IPV6" != "$CURRENT_AAAA_RECORD" ]]; then
	echo "[INFO][PORKBUN] Updating AAAA record | From: \"$CURRENT_AAAA_RECORD\" to \"$SERVER_IPV6\""
	STATUS=$(update_porkbun "AAAA" "$SERVER_IPV6")

	if [[ "$STATUS" == "ERR" ]]; then
		echo "[ERROR][PORKBUN] Failed to update the AAAA record" >&2
		exit 1
	fi
else
	echo "[SUCCESS] AAAA record unchanged."
fi
