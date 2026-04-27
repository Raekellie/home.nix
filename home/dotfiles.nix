{
	inputs,
		config,
		pkgs,
		lib,
		...
}:

{
# HM sets a guard against these being sourced more than once per login which makes quick tweaks maddening
	home = {
		sessionVariables = {
			VIMINIT = "source ${config.xdg.configHome}/vim/vimrc";
		};

		sessionPath = [
			"${inputs.dotfiles}/environment/path"
		];
	};

	programs.zsh.initContent = lib.fileContents ("${inputs.dotfiles}/config/zsh/.zshrc");

	xdg.configFile = {
		"vim".source = "${inputs.dotfiles}/config/vim";
		"kitty".source = "${inputs.dotfiles}/config/kitty";
		"ranger".source = "${inputs.dotfiles}/config/ranger";
		"gdb".source = "${inputs.dotfiles}/config/gdb";

		"starship.toml".source = "${inputs.dotfiles}/config/starship.toml";
	};
}
