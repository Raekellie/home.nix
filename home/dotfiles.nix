{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    sessionVariables = {
      VIMINIT = "source ${inputs.dotfiles}/config/vim/vimrc";
    };
  };

  xdg.configFile = {
    "vim".source = "${inputs.dotfiles}/config/vim";
    "ranger".source = "${inputs.dotfiles}/config/ranger";
    "gdb".source = "${inputs.dotfiles}/config/gdb";

    "kitty".source = "${inputs.dotfiles}/config/kitty";
  };
}
