{inputs, ...}: {
	imports = [
		inputs.sops-nix.nixosModules.sops
	];

	# Important: `sops-nix` only accepts strings as valid key values, and no others
	sops = {
		defaultSopsFile = ./default.yaml;

		age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

		secrets = {
			initialHashedPassword = {neededForUsers = true;};
			nixAccessTokens = {};
		};
	};
}
