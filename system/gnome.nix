{pkgs, ...}: {
  services = {
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      autoLogin.user = "raquel";
    };
    gnome.core-apps.enable = true;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;
  };

  #environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];
  environment.systemPackages = with pkgs; [];
}
