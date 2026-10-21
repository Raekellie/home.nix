{
	pkgs,
	config,
	...
}: {
	# Highly based on the information at https://wiki.nixos.org/wiki/Uninterruptible_power_supply

	# The systemd service that will make the UPS shut down a few seconds after the server does, in the case of an outage
	# Copied from ConfigExamples 3.0 book, Appendix B.2.
	systemd.services.nut-delayed-ups-shutdown = {
		enable = true;
		environment = config.systemd.services.upsmon.environment;
		description = "Trigger a delayed UPS shutdown";
		before = ["umount.target"];
		wantedBy = ["final.target"];
		serviceConfig = {
			Type = "oneshot";
			# Must be run as root
			ExecStart = ''${pkgs.nut}/bin/upsdrvctl -u root shutdown'';

			# Must not use the option `Slice`: if used, `upsdrvctl` will not run as a late shutdown service
		};
		unitConfig = {
			ConditionPathExists = config.power.ups.upsmon.settings.POWERDOWNFLAG;
			DefaultDependencies = "no";
		};
	};

	# UPS driver - `upsd` (NUT)
	power.ups = {
		enable = true;
		mode = "standalone";

		ups."UPS-0" = {
			description = "Eaton 5E Gen2 (5E1200UI)";
			driver = "usbhid-ups";
			port = "auto";

			directives = [
				# "Restore power on AC" BIOS option needs power to be cut for a few seconds to work
				# This is achieved via the directives below

				# When shutting down, the service above calls `upsdrvctl shutdown` to tell the UPS that
				# after x seconds, the UPS power must be cut, even if line power returns.
				# There is a risk that the system takes longer than the default 20 seconds to shut down.
				# This is set to a higher value to solve this issue.
				"override.ups.delay.shutdown = 60"

				# UPS power is now cut regardless of line power. After y seconds, if line power returns, then turn on
				# UPS power. The system has now been offline for the difference between these two timings, and the BIOS
				# should turn the system back on by itself.
				# The value below must always be higher than the previous for this to work.
				"override.ups.delay.start = 70" # Default: 30

				# Set the low battery condition to slightly higher to account for the longer delay to shut down
				"override.battery.charge.low = 30" # Default: 20
			];
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

		# Monitor, react to UPS events - `upsmon`
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
