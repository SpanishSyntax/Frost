{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.storage.impermanence;
  rootDevice = config.fileSystems."/".device or "";
  isBtrfsRoot = (config.fileSystems."/".fsType or "") == "btrfs";
in {
  options.frost.storage.impermanence = {
    rollbackBtrfsInitrd = lib.mkOption {
      type = lib.types.bool;
      default = isBtrfsRoot;
      description = "Whether to hook the destructive Btrfs rollback script into the initrd stage.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.rollbackBtrfsInitrd) {
    boot.initrd.supportedFilesystems = ["btrfs"];
    boot.initrd.systemd.enable = true;

    boot.initrd.systemd.storePaths = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.findutils
      pkgs.age-plugin-yubikey
    ];

    boot.initrd.systemd.services.btrfs-root-rollback = {
      description = "Reset Btrfs root subvolume to pristine template state";
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      wantedBy = ["initrd-root-fs.target"];
      before = ["sysroot.mount"];
      after = ["local-fs-pre.target"];

      script = ''
        mkdir -p /btrfs_tmp
        echo "Mounting top-level Btrfs volume using discovered device: ${rootDevice}"
        mount "${rootDevice}" /btrfs_tmp

        # 1. Archive the dirty root out of the way safely and idempotently
        if [[ -e /btrfs_tmp/@ ]]; then
          mkdir -p /btrfs_tmp/old_roots

          timestamp=$(stat -c %Y /btrfs_tmp/@)

          # Only attempt the move if this specific target snapshot folder doesn't already exist
          if [[ ! -e "/btrfs_tmp/old_roots/$timestamp" ]]; then
              mv /btrfs_tmp/@ "/btrfs_tmp/old_roots/$timestamp"
          else
              echo "Root directory already archived for this timestamp interval. Skipping."
              # If the target exists but an orphan root is still loose, clean it safely
              btrfs subvolume delete /btrfs_tmp/@
          fi
        fi

        # 2. Upstream deep-pruning function definition
        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        # 3. Clean up old roots older than 30 days (completely isolated from active boot path)
        echo "Pruning historical roots older than 30 days..."
        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        # 4. Re-create the active root from the pristine template snapshot
        echo "Restoring pristine blank template..."
        btrfs subvolume snapshot /btrfs_tmp/@blank /btrfs_tmp/@

        umount /btrfs_tmp
      '';
    };
  };
}
