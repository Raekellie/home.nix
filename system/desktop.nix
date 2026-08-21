{
  config,
  pkgs,
  ...
}: {
  programs = {
    appimage.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    firefox = {
      enable = true;
      package = pkgs.librewolf;

      # Librewolf does basically all of what I want by default
      # ---
      # Reference - policies: https://mozilla.github.io/policy-templates/#preferences
      # Reference - about:config options: https://searchfox.org/firefox-main/source/browser/components/StartupTelemetry.sys.mjs#363
      # Practical example: https://wiki.nixos.org/wiki/Firefox/en#Advanced
      # Additional examples by a blogger: https://www.sacredheartsc.com/blog/browser-de-slop/
    };
  };

  services = {
    flatpak.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        FastConnectable = true;
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

    # For when I, sadly, need a Blink-based browser (WebUSB...)
    ungoogled-chromium

    # Multimedia
    mpv

    # E-reader
    calibre

    # Office suite
    libreoffice-qt-fresh
    hunspell
    hunspellDicts.pt_PT
    hunspellDicts.en_GB-ize

    # Assorted
    imagemagick
    qbittorrent
  ];

  fonts.packages = with pkgs; [
    liberation_ttf
    dejavu_fonts

    # One of these may become my new preference over Liberation and Dejavu
    inter
    ibm-plex

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    iosevka
    nerd-fonts.iosevka-term
  ];
}
