{pkgs, ...}: {
	home = {
		shell.enableShellIntegration = true;
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
