{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.impermanence-btrfs;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options = {
    custom.impermanence-btrfs = with lib; {
      enable = mkEnableOption "Aid in setting up impermanence with BTRFS as the root filesystem";
      rootDevice = mkOption {
        type = types.nonEmptyStr;
        default = null;
        description = "Path to the root device containing the BTRFS filesystem. This must be set!";
        example = "/dev/root_vg/root";
      };
      daysToKeep = mkOption {
        type = types.int;
        default = 30;
        description = "How long to keep a snapshot for until its deletion, in days";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      enable = true;
      supportedFilesystems = ["btrfs"];

      # Sources: (unsure which is the primary)
      # https://github.com/nix-community/impermanence/blob/master/README.org#btrfs-subvolumes
      # https://guekka.github.io/nixos-server-1/
      # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
      postResumeCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount "${cfg.rootDevice}" /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
        	mkdir -p /btrfs_tmp/old_roots
        	timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        	mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
        	IFS=$'\n'
        	for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        		delete_subvolume_recursively "/btrfs_tmp/$i"
        	done
        	btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${cfg.daysToKeep}; do
        	delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };
  };
}
