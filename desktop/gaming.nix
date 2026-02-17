{ config, pkgs, ... }:

{
  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.wivrn.enable = false;

  environment.systemPackages = with pkgs; [
    #lutris
    #steam-run

    #prismlauncher
    #openjdk-minimal-jre
  ];
}
