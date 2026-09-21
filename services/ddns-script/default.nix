{
	inputs,
	config,
	pkgs,
	...
}: {
	systemd = {
		services."ddns-script" = {
			enable = true;
			description = "Update the DNS records for my domain to point to the current machine";
			path = with pkgs; [
				bash
				curl
				jq
				iproute2 # ip
				coreutils-full # cut
				gawk # awk
			];
			serviceConfig = {
				Type = "oneshot";
				ExecStart = "${inputs.self}/services/ddns-script/script.sh";
				LoadCredential = [
					"${config.sops.secrets.services-ddns-routerHeaders.path}"
					"${config.sops.secrets.services-ddns-porkbunHeaders.path}"
				];
			};
		};
		timers."ddns-script" = {
			enable = true;
			description = "Runs ddns-script 3min after booting and every 15min henceforth";
			wantedBy = ["timers.target"];
			timerConfig = {
				OnBootSec = "3min";
				OnUnitActiveSec = "15min";
			};
		};
	};
}
