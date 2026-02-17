{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixfmt
    #rustup

    #git-filter-repo

    #godotPackages.godot
    #godotPackages.godot-export-templates-bin
    #steam-run # Useful to be able to run Godot games without messing with paths
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
}
