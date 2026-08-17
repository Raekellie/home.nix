{
  pkgs-unstable,
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

  # FIXME: Add an option for VR (WiVRn + LACT) and possibly move this section to hosts/deskel/default.nix
  services = {
    lact = {
      enable = true;
      settings = {
        version = 5;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        gpus = {
          "1002:7590-148C:2437-0000:09:00.0" = {
            fan_control_enabled = false;
            pmfw_options = {
              zero_rpm = true;
            };
            performance_level = "auto";
          };
        };
        profiles = {
          VR = {
            gpus = {
              "1002:7590-148C:2437-0000:09:00.0" = {
                fan_control_enabled = false;
                pmfw_options = {
                  zero_rpm = true;
                };
                performance_level = "manual";
                power_profile_mode_index = 4;
              };
            };
            rule = {
              type = "process";
              filter = {
                name = "wayvr";
              };
            };
          };
        };
        current_profile = null;
        auto_switch_profiles = true;
      };
    };

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

    pkgs-unstable.wayvr
  ];

  # https://github.com/NixOS/nixpkgs/pull/396595
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
}
