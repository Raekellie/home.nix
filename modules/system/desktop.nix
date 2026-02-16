{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.appimage.enable = true;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kitty
  ];
}
