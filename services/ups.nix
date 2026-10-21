{config, ...}: {
	# https://wiki.nixos.org/wiki/Uninterruptible_power_supply

	# Configuration on the UPS side - `upsd`
	power.ups = {
		enable = true;
		mode = "standalone";

		ups."UPS-0" = {
			description = "Eaton 5E Gen2 (5E1200UI)";
			driver = "usbhid-ups";
			port = "auto";
		};

		# To allow for communication between `upsd` and `upsmon`
		upsd = {
			listen = [
				{
					address = "127.0.0.1";
					port = 3493;
				}
				{
					address = "::1";
					port = 3493;
				}
			];
		};

		# NUT administration user, unrelated to system users
		users."raquel" = {
			passwordFile = "${config.sops.secrets.services-ups-admin-password.path}";
			upsmon = "primary";
		};

		# Configuration on the machine side - `upsmon`
		upsmon = {
			# Wire it up to `upsd`
			monitor."UPS-0" = {
				system = "UPS-0@localhost";
				user = "raquel";
				passwordFile = "${config.sops.secrets.services-ups-admin-password.path}";
				type = "primary";
			};

			settings = {
				# `POWERDOWNFLAG` and `SHUTDOWNCMD` have defaults set by NixOS
				# Values from the ConfigExamples 3.0 book
				NOTIFYMSG = [
					["ONLINE" ''"UPS %s: On line power."'']
					["ONBATT" ''"UPS %s: On battery."'']
					["LOWBATT" ''"UPS %s: Battery is low."'']
					["REPLBATT" ''"UPS %s: Battery needs to be replaced."'']
					["FSD" ''"UPS %s: Forced shutdown in progress."'']
					["SHUTDOWN" ''"Auto logout and shutdown proceeding."'']
					["COMMOK" ''"UPS %s: Communications (re-)established."'']
					["COMMBAD" ''"UPS %s: Communications lost."'']
					["NOCOMM" ''"UPS %s: Not available."'']
					["NOPARENT" ''"upsmon parent dead, shutdown impossible."'']
				];
				NOTIFYFLAG = [
					["ONLINE" "SYSLOG+WALL"]
					["ONBATT" "SYSLOG+WALL"]
					["LOWBATT" "SYSLOG+WALL"]
					["REPLBATT" "SYSLOG+WALL"]
					["FSD" "SYSLOG+WALL"]
					["SHUTDOWN" "SYSLOG+WALL"]
					["COMMOK" "SYSLOG+WALL"]
					["COMMBAD" "SYSLOG+WALL"]
					["NOCOMM" "SYSLOG+WALL"]
					["NOPARENT" "SYSLOG+WALL"]
				];

				# Every `RBWARNTIME` seconds, `upsmon` will warn to replace the battery
				RBWARNTIME = 216000;

				# Every `NOCOMMWARNTIME` seconds, `upsmon` will warn that the device is unreachable
				NOCOMMWARNTIME = 300;

				# Time in seconds to wait before executing the `SHUTDOWNCMD`, after warning users of the impeding shutdown
				# From wiki: "Some UPS' don't give much of a warning for low battery and will require a value of 0 here for a
				# safe shutdown"
				FINALDELAY = 0;
			};
		};
	};
}
