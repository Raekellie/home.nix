{
  inputs,
  lib,
  config,
  utils,
  ...
}: let
  cfg = config.custom.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options = with lib; {
    custom.impermanence = {
      enable = mkEnableOption "Set up impermanence to persist common paths";
      persistPath = mkOption {
        type = types.nonEmptyStr;
        default = null;
        description = "Where to persist files in. This must be set!";
        example = "/persist";
      };

      btrfs = {
        enable = mkEnableOption "Aid in setting up impermanence with BTRFS as the root filesystem";
        rootDevice = mkOption {
          type = types.nonEmptyStr;
          default = null;
          description = "Path to the root device containing the BTRFS filesystem. This must be set!";
          example = "/dev/root_vg/root, /dev/mapper/crypt";
        };
        rootSubvol = mkOption {
          type = types.nonEmptyStr;
          default = "root";
          description = "Name of the subvolume used for root";
        };
        daysToKeep = mkOption {
          type = types.ints.positive;
          default = 30;
          description = "How long to keep a snapshot for until its deletion, in days";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      #FIXME: throws error because fsType isn't set up yet, which won't happen once I finish fleshing out the config
      #fileSystems."${cfg.persistPath}" = {neededForBoot = true;};

      environment.persistence."${cfg.persistPath}" = {
        directories = [
          "/etc/nixos"

          # The article below also suggest persisting these files. Left here for reference in case I realise I need that too
          # /var/lib/NetworkManager/{secret_key,seen-bssids,timestamps}
          # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
          "/etc/NetworkManager/system-connections"

          "/var/lib/nixos"
          "/var/log"
        ];
        files = [
          "/etc/machine-id"
          "/etc/adjtime"

          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };

      security.sudo.extraConfig = ''
        # Don't get lectured in security after each reboot :p
        Defaults lecture = never
      '';
    })
    (lib.mkIf (cfg.enable && cfg.btrfs.enable) {
      # NixOS uses systemd bootup as of 26.05 (bootup(7)#System Manager Bootup)
      # https://github.com/nix-community/impermanence/pull/321
      boot.initrd.systemd = {
        enable = true; # Default in 26.05 FIXME: remove once 26.05 stabilizes
        services.wipe-btrfs-root = {
          # Specify dependencies explicitly
          unitConfig.DefaultDependencies = false;

          # Ensure the script finishes for the service to complete
          serviceConfig.Type = "oneshot";

          # `wantedBy` allows the system to boot even if this service fails, allowing for an easy recovery
          # `requiredBy` will cause the bootup to fail if this service is unsuccessful
          wantedBy = ["initrd.target"];

          # Must complete before any filesystems are mounted
          before = ["sysroot.mount"];

          # Wait for the device to appear
          requires = ["${utils.escapeSystemdPath cfg.btrfs.rootDevice}.device"];
          after = [
            "${utils.escapeSystemdPath cfg.btrfs.rootDevice}.device"
            "cryptsetup.target"
            # Allow hibernation to resume before trying to alter any data
            "local-fs-pre.target"
          ];

          script = ''
            mkdir /mnt
            mount "${cfg.btrfs.rootDevice}" /mnt

            if [[ -e /mnt/${cfg.btrfs.rootSubvol} ]]; then
            	mkdir -p /mnt/old_roots
            	timestamp=$(date --date="@$(stat -c %Y /mnt/${cfg.btrfs.rootSubvol})" "+%Y-%m-%-d_%H:%M:%S")
            	mv /mnt/${cfg.btrfs.rootSubvol} "/mnt/old_roots/$timestamp"
            fi

            for i in $(find /mnt/old_roots/ -maxdepth 1 -mtime +${lib.toString cfg.btrfs.daysToKeep}; do
            	btrfs subvolume delete --recursive "$i"
            done

            btrfs subvolume create /mnt/${cfg.btrfs.rootSubvol}
            umount /mnt
          '';
        };
      };
    })
  ];
}
