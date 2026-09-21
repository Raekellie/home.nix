{...}: {
	sops = {
		secrets = {
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
