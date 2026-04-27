{ config, pkgs, ... }:

{

  # For better perfomance in Wine/Proton
  boot.kernelModules = [ "ntsync" ];

  programs.steam = {
    enable = false;
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
}
