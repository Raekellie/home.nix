# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Bootloader
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 5;
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  #
  # Connectivity
  #

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Printing (CUPS)
  services.printing.enable = true;

  # Sound (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    #alsa.support32Bit = true;
  };

  # User
  users = {
    users."raquel" = {
      # Don't forget to use `passwd`
      isNormalUser = true;
      description = "Raquel";
      extraGroups = [
        "wheel"
        "networkmanager"
        "vboxsf"
      ];
      packages = with pkgs; [ ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Read the docs/release notes before changing this value
  # (man configuration.nix, https://nixos.org/nixos/options.html, https://nixos.org/manual/nixos/stable/release-notes)
  system.stateVersion = "26.05";
}
