{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  home.sessionVariables = {
    DOTFILES = "${inputs.dotfiles}";
  };

  programs.zsh.initContent = lib.fileContents ("${inputs.dotfiles}/config/zsh/.zshrc");

  # Vim already has its VIMINIT set within the .zshrc
  xdg.configFile = {
    "kitty".source = "${inputs.dotfiles}/config/kitty";
    "ranger".source = "${inputs.dotfiles}/config/ranger";
    "gdb".source = "${inputs.dotfiles}/config/gdb";
  };
}
