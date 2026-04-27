{ config, pkgs, ... }:

{
  #
  # Nix
  #
  nix = {
    channel.enable = false;

    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Storage optimisations
    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  #
  # nh
  #
  programs.nh = {
    enable = false;
    clean.enable = false;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "$HOME/nixos-config";
  };

  #
  # Services
  #
  services = {
    fstrim.enable = true;
  };

  #
  # Locale
  #
  time.timeZone = "Europe/Lisbon";
  i18n = {
    defaultLocale = "en_IE.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_PT.UTF-8";
      LC_IDENTIFICATION = "pt_PT.UTF-8";
      LC_MEASUREMENT = "pt_PT.UTF-8";
      LC_MONETARY = "pt_PT.UTF-8";
      LC_NAME = "pt_PT.UTF-8";
      LC_NUMERIC = "pt_PT.UTF-8";
      LC_PAPER = "pt_PT.UTF-8";
      LC_TELEPHONE = "pt_PT.UTF-8";
      LC_TIME = "pt_PT.UTF-8";
    };
  };

  #
  # Base firewall setings
  #
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
