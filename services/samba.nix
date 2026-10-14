{...}: {
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
			"raquel" = {
				"path" = "/storage/shared/raquel";
				"browseable" = "yes";
				"read only" = "no";
				"guest ok" = "no";
				"create mask" = "0644";
				"directory mask" = "0755";
				"force user" = "raquel";
			};
		};
	};

	# Discovery (for Windows machines) - from NixOS wiki
	#services.samba-wsdd = {
	#	enable = true;
	#	openFirewall = true;
	#};
	#services.avahi = {
	#	enable = true;
	#	publish.enable = true;
	#	publish.userServices = true;
	#	openFirewall = true;
	#};
}
