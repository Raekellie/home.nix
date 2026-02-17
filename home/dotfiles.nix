{ inputs, config, pkgs, ... }:

{
  # This doesn't work without having HM manage ZSH itself
  #home.sessionVariables = {
  #  DOTFILES        = "${inputs.dotfiles}";
  #  ZDOTDIR         = "${inputs.dotfiles}/config/zsh";
  #};

  home.file.".config/kitty".source  = "${inputs.dotfiles}/config/kitty";
  home.file.".config/ranger".source = "${inputs.dotfiles}/config/ranger";
  home.file.".config/gdb".source    = "${inputs.dotfiles}/config/gdb";
  # Vim has its VIMINIT set within the .zshrc already
}
