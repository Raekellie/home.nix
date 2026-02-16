{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
  ];

  programs.zsh = {
    shellAliases = {
      "flakeswitch" = "sudo nixos-rebuild switch --flake $HOME/cfg#nixos";
    };
  };
}
