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
    ../../system/winbox.nix
  ];

  custom.impermanence = {
    enable = true;
    persistPath = "/persist";

    btrfs = {
      enable = true;
      rootDevice = "/dev/mapper/crypt";
      rootSubvol = "root";
      daysToKeep = 14;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
        memtest86.enable = true;
        #netbootxyz.enable = true; # Reminder for self that this is an option
      };
    };

    # "Silent" boot
    # https://wiki.nixos.org/wiki/Plymouth
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];

    plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };

  networking = {
    hostName = "deskel";
    networkmanager.enable = true;
  };

  services = {
    printing.enable = true;
    avahi = {
      nssmdns4 = true; # Necessary for .local resolution, which the printer requires
    };

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
      ];
      openssh.authorizedKeys.keys = [
        ""
      ];
      hashedPasswordFile = config.sops.secrets.initialHashedPassword.path;
      packages = with pkgs; [];
    };
  };

  # Use ROCm & HIP enabled packages for those that support it
  nixpkgs.config.rocmSupport = true;

  # Read the docs/release notes before changing this value
  # (man configuration.nix, https://nixos.org/nixos/options.html, https://nixos.org/manual/nixos/stable/release-notes)
  system.stateVersion = "26.05";
}
