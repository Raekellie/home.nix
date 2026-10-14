{...}: {
	sops = {
		secrets = {
			"services-samba-user-password-raquel" = {
				sopsFile = ./samba-user-passwords.yaml;
				neededForUsers = true;
			};

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
