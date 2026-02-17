{ config, pkgs, ... }:

{
  home.username = "raquel";
  home.homeDirectory = "/home/raquel";
  xdg.enable = true;

  imports = [
    ./dotfiles.nix
    ./shell.nix
    ./dev.nix
    ./desktop.nix
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
