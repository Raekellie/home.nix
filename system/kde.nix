{
  pkgs,
  lib,
  ...
}: {
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      plasma-login-manager.enable = true;
      autoLogin.user = "raquel"; # FIXME: clean up this ugly hardcoding
    };
  };

  programs = {
    kdeconnect.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.discover # Software center (useful for flatpaks)
    kdePackages.kcalc
    kdePackages.kcharselect # Special character picker
    kdePackages.kclock
    kdePackages.kcolorchooser # Colour picker
    kdePackages.kolourpaint # Paint
    kdePackages.ksystemlog # System log viewer
    kdePackages.kate
    kdePackages.filelight # Disk space usage visualiser

    kdiff3 # Compares and merges 2 or 3 files or directories

    kdePackages.kleopatra
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
  ];
}
