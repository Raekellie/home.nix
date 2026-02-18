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
      DOTFILES = "${inputs.dotfiles}";

      VIMINIT = "source ${inputs.dotfiles}/config/vim/vimrc";
      STARSHIP_CONFIG = "${inputs.dotfiles}/config/starship.toml";
    };

    sessionPath = [
      "${inputs.dotfiles}/environment/path"
    ];
  };

  programs.zsh.initContent = lib.fileContents ("${inputs.dotfiles}/config/zsh/.zshrc");

  xdg.configFile = {
    "kitty".source = "${inputs.dotfiles}/config/kitty";
    "ranger".source = "${inputs.dotfiles}/config/ranger";
    "gdb".source = "${inputs.dotfiles}/config/gdb";
  };
}
