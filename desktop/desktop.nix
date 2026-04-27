{ config, pkgs, ... }:

{
  programs.appimage.enable = true;
  services.flatpak.enable = true;

  programs.firefox = {
    enable = true;
    # Reference: https://mozilla.github.io/policy-templates/#preferences
    # List of about:config options: https://searchfox.org/firefox-main/source/browser/components/StartupTelemetry.sys.mjs#363
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;

      "browser.ai.control.default" = "blocked";
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
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
    # General tools
    kitty
    wl-clipboard
    hardinfo2
    wayland-utils

    qalculate-qt

    # Multimedia
    mpv

    # E-reader
    calibre

    # Alternative Chromium-based browser for the rare times I need it
    vivaldi

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
  ];
}
