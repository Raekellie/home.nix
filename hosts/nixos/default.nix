# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../impermanence.nix
    ../../system
  ];

  custom.impermanence = {
    enable = true;
    persistPath = "/persist";

    btrfs = {
      enable = true;
      rootDevice = "/dev/mapper/secure";
      rootSubvol = "root";
      daysToKeep = 14;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 5;
    memtest86.enable = true;
    netbootxyz.enable = false; # Reminder for self that this is an option
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  services = {
    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      #alsa.support32Bit = true;
    };
  };

  security = {
    rtkit.enable = true;
  };

  users = {
    mutableUsers = false;
    users."raquel" = {
      isNormalUser = true;
      description = "Raquel";
      extraGroups = [
        "wheel"
        "networkmanager"
        "vboxsf"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBC2ym8cwJrrOR08Fw+nJl6p/8tTESltZRbnMLaNfA72 raquel@mermaid"
      ];
      hashedPasswordFile = config.sops.secrets.initialHashedPassword.path;
      packages = with pkgs; [];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Read the docs/release notes before changing this value
  # (man configuration.nix, https://nixos.org/nixos/options.html, https://nixos.org/manual/nixos/stable/release-notes)
  system.stateVersion = "26.05";
}
