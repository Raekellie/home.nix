{ config, pkgs, ... }:

{
  #hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    #rustup

    #git-filter-repo

    #godotPackages.godot
    #godotPackages.godot-export-templates-bin
    #steam-run # Useful to be able to run Godot games without messing with paths
  ];
}
