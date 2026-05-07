{
  nixpkgs,
  pkgs,
  ...
}:

{

  # For better perfomance in Wine/Proton
  boot.kernelModules = [ "ntsync" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services = {
    wivrn.enable = false;

    # Network throughput testing utility - useful for checking there is enough bandwidth for VR
    iperf3 = {
      enable = false;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    #faugus-launcher
    #steam-run

    #prismlauncher
    #openjdk-minimal-jre
  ];

  # https://github.com/NixOS/nixpkgs/pull/396595
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
}
