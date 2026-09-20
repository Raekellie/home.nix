{inputs, ...}: {
	imports = [
		inputs.sops-nix.nixosModules.sops
	];

	sops = {
		defaultSopsFile = ./secrets.yaml; # This will be dropped in the nix store

		age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

		secrets = {
			initialHashedPassword = {neededForUsers = true;};

			biglab_ddns_headers_router = {
				format = "binary";
				sopsFile = ./headers_router.enc;
			};
			biglab_ddns_headers_porkbun = {
				format = "binary";
				sopsFile = ./headers_porkbun.enc;
			};
		};
	};
}
