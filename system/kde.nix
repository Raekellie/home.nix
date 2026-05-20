{
  config,
  pkgs,
  ...
}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin.user = "raquel"; # FIXME: clean up this ugly hardcoding
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  programs = {
    kdeconnect.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.discover # Software center (useful for flatpaks)
    kdePackages.kcalc
    kdePackages.kcharselect # Special character picker
    kdePackages.kclock
    kdePackages.kcolorchooser # Colour picker
    kdePackages.kolourpaint # Paint
    kdePackages.ksystemlog # System log viewer
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdePackages.kate
    kdePackages.filelight # Disk space usage visualiser

    kdiff3 # Compares and merges 2 or 3 files or directories

    kdePackages.isoimagewriter
    kdePackages.partitionmanager
  ];
}
