{ config, pkgs, ... }:

{
  programs.lutris.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.wivrn.enable = true;
}
