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
          example = "/dev/root_vg/root";
        };
        daysToKeep = mkOption {
          type = types.ints.positive;
          default = 30;
          description = "How long to keep a snapshot for until its deletion, in days";
        };
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.btrfs.enable) {
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
          # Allow hibernation to resume before trying to alter any data
          "local-fs-pre.target"
        ];

        script = ''
          mkdir /btrfs_tmp
          mount "${cfg.btrfs.rootDevice}" /btrfs_tmp

          if [[ -e /btrfs_tmp/root ]]; then
          	mkdir -p /btrfs_tmp/old_roots
          	timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          	mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${lib.toString cfg.btrfs.daysToKeep}; do
          	btrfs subvolume delete --recursive "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    };
  };
}
