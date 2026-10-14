{config, ...}: {
	# References:
	# https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
	# https://wiki.nixos.org/wiki/Samba#Server_setup; https://wiki.archlinux.org/title/Samba
	services.samba = {
		enable = true;
		openFirewall = true;
		settings = {
			global = {
				"workgroup" = "WORKGROUP";
				"server string" = "%h";
				"netbios name" = "%h";
				"server role" = "standalone";
				"security" = "user";
				"use sendfile" = "yes";
				"hosts allow" = "192.168.20. 192.168.25. 127.0.0.1 localhost";
				"hosts deny" = "0.0.0.0/0";
				"guest account" = "nobody";
				"map to guest" = "bad user";
			};
			"samba-raquel" = {
				"path" = "/storage/shared/samba-raquel";
				"browseable" = "yes";
				"read only" = "no";
				"guest ok" = "no";
				"create mask" = "0644";
				"directory mask" = "0755";
				"force user" = "samba-raquel";
				"valid user" = "samba-raquel";
			};
		};
	};

	# Users
	users.users."samba-raquel" = {
		description = "Write-access to Samba shares";
		extraGroups = ["users"];
		hashedPasswordFile = config.sops.secrets.services-samba-user-password-raquel.path;
		isNormalUser = true;
	};
	system.activationScripts = {
		# The password is repeated twice with newline characters as `smbpasswd` requires a password confirmatio even in
		# non-interactive mode where input is piped in through stdin.
		"custom_samba_user_passwords".text = ''
			/run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets.services-samba-user-password-raquel.path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets.services-samba-user-password-raquel.path})\n" | /run/current-system/sw/bin/smbpasswd -sa samba-raquel
		'';
	};

	# Discoverability
	services.samba-wsdd = {
		enable = true;
		openFirewall = true;
	};
	services.avahi = {
		enable = true;
		publish.enable = true;
		publish.userServices = true;
		openFirewall = true;
	};
}
