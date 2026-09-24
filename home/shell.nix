{pkgs, ...}: {
	home = {
		shell.enableShellIntegration = true;
		shellAliases = {
			# I really should consider configuring fish purely with Nix, without any config.fish
			#"nixalias" = "nixos-rebuild --sudo --flake $HOME/dev/nix/home.nix";
			#"nixalias-dev" = "nixalias --override-input dotfiles $HOME/dev/nix/dotfiles";
		};
	};

	programs = {
		nushell.enable = false;

		# https://blog.gitbutler.com/how-git-core-devs-configure-git (not using all the suggestions)
		# Review once Git 3.0 is out
		git = {
			enable = true;
			settings = {
				user = {
					name = "Raquel";
					email = "ela@raquellie.com";
				};

				diff = {
					algorithm = "histogram";
					colorMoved = "plain";
					renames = true;
					mnemonicPrefix = true;
				};
				help = {
					autocorrect = "prompt";
				};
				init = {
					defaultBranch = "main";
				};
				merge = {
					conflictstyle = "zdiff3";
				};
				push = {
					autoSetupRemote = true;
					followTags = true;
				};
			};
		};
	};

	home.packages = with pkgs; [];
}
