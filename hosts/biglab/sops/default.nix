{...}: {
	sops = {
		secrets = {
			# Samba
			"services-samba-user-password-raquel" = {
				sopsFile = ./samba-user-passwords.yaml;
				neededForUsers = true;
			};

			# UPS
			"services-ups-admin-password" = {
				sopsFile = ./ups-passwords.yaml;
			};

			# DDNS script
			"services-ddns-routerHeaders" = {
				format = "binary";
				sopsFile = ./headers_router.enc;
			};
			"services-ddns-porkbunHeaders" = {
				format = "binary";
				sopsFile = ./headers_porkbun.enc;
			};
		};
	};
}
