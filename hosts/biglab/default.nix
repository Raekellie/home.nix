{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../impermanence.nix
    #../../system
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
  };

  networking = {
    hostName = "biglab";
    networkmanager.enable = true;
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

  # Read the docs/release notes before changing this value
  # (man configuration.nix, https://nixos.org/nixos/options.html, https://nixos.org/manual/nixos/stable/release-notes)
  system.stateVersion = "26.05";
}
