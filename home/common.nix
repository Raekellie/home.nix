{osConfig, ...}: {
	imports = [
		./dotfiles.nix
		./shell.nix
	];
	xdg.enable = true;

	nix = {
		assumeXdg = true;
		extraOptions = ''!include ${osConfig.sops.secrets.nixAccessTokens.path}'';
	};

	# Read the docs/release notes before changing this value
	# ( https://nix-community.github.io/home-manager/release-notes/release-notes.html )
	home.stateVersion = "26.11";
}
