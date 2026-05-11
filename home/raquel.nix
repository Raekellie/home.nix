{ config, pkgs, ... }:

{
  home.username = "raquel";
  xdg.enable = true;

  imports = [
    ./dotfiles.nix
    ./shell.nix
  ];

  # Read the docs/release notes before changing this value
  # (https://nix-community.github.io/home-manager/release-notes.xhtml)
  home.stateVersion = "26.05";
}
