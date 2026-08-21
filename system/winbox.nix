{...}: {
  # Utility by Mikrotik to configure their devices, whose UI is a bit nicer than the web management page ("WebFig")
  programs.winbox = {
    enable = true;
    openFirewall = true;
  };

  nixpkgs.config.allowUnfreePackages = [
    "winbox"
  ];
}
