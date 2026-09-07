{
	nixpkgs,
	pkgs,
	modulesPath,
	...
}: {
	# https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
	imports = [
		(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
		../../services/ssh.nix
		../../system/utilities.nix
	];

	networking.hostName = "nixos-live-image";

	systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
	users.users."nixos".openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzHOnKrV5nCvwKlGZxyKHkyiFcLzWmsZIVWX5iiw/V3 openpgp:0x413758D0"
	];

	programs.vim.package = pkgs.vim;

	isoImage.squashfsCompression = "zstd";
	environment.systemPackages = with pkgs; [];

	nixpkgs.hostPlatform = "x86_64-linux";
	# FIXME: Remove after updating to 26.11 (new default). Set here to supress eval warning
	boot.zfs.forceImportRoot = false;
	# Read the docs/release notes before changing this value
	# (man configuration.nix, https://nixos.org/nixos/options.html, https://nixos.org/manual/nixos/stable/release-notes)
	system.stateVersion = "26.05";
}
