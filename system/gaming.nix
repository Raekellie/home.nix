{
  nixpkgs,
  pkgs,
  ...
}: {
  # For better perfomance in Wine/Proton
  boot.kernelModules = ["ntsync"];

  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      package = pkgs.steam.override {
        extraBwrapArgs = [
          # For WiVRn - disable the need to set this for every VR game
          "--setenv PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES '1'"

          # For posterity
          # This breaks WiVRn. It's beautiful and works for everything else, but not VR
          # "--bind $HOME/games/steam $HOME"
        ];
      };
    };
  };

  services = {
    wivrn = {
      enable = true;
      openFirewall = true;
      highPriority = true;
      steam.enable = true;
    };

    # Network throughput testing utility - useful for checking whether there is enough bandwidth for VR
    iperf3 = {
      enable = false;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    steam-run
    prismlauncher
    #faugus-launcher # Currently prefer using it as a Flatpak for its inherent sandboxing
  ];

  # https://github.com/NixOS/nixpkgs/pull/396595
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
}
