{ config, pkgs, ... }:

{
  programs.appimage.enable = true;
  services.flatpak.enable = true;

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  services.qbittorrent.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # General (TODO: split this up into its own file if I ever switch to another DE)
    wl-clipboard
    kitty
    hardinfo2
    wayland-utils

    calibre

    # Libreoffice
    libreoffice-qt-fresh
    hunspell
    hunspellDicts.pt_PT
    hunspellDicts.en_GB-ize
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    dejavu_fonts

    nerd-fonts.iosevka
  ];
}
