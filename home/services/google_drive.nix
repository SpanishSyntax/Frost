{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.services.google_drive;

  envIgnores = config.frost.home.environment.ignores;
  rclonePatterns =
    (map (d: "- ${d}/**") envIgnores.directories)
    ++ (map (f: "- ${f}") envIgnores.files);
  excludeFile = pkgs.writeText "rclone-workspace-excludes.txt" (
    lib.concatStringsSep "\n" rclonePatterns + "\n"
  );
in {
  options.frost.home.services.google_drive = {
    enable = lib.mkEnableOption "Google Drive FUSE Mount & Direct Sync Tool";

    workspaceDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Workspace";
      description = "Local workspace root directory to sync.";
    };

    mountDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/GDrive";
      description = "Mount point directory for rclone FUSE mount.";
    };

    remoteName = lib.mkOption {
      type = lib.types.str;
      default = "gdrive";
      description = "Name of the rclone remote configured in rclone.conf.";
    };

    rcloneConfigFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/rclone/rclone.conf";
      description = "Path to the rclone configuration file.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/rclone/.keep".text = "";

    home.packages = [
      pkgs.rclone
      (pkgs.writeShellApplication {
        name = "sync-workspace";
        runtimeInputs = [
          pkgs.rclone
          pkgs.coreutils
        ];
        text = ''
          set -euo pipefail

          DEFAULT_SRC="${cfg.workspaceDir}"
          DEFAULT_REMOTE="${cfg.remoteName}:"
          CONFIG="${cfg.rcloneConfigFile}"

          SRC_OVERRIDE=""
          DEST_OVERRIDE=""
          SUBDIR=""
          EXTRA_ARGS=()

          usage() {
            cat <<EOF
          Usage: sync-workspace [SUBDIR] [OPTIONS] [-- RCLONE_FLAGS...]

          Syncs local workspace directories directly to Google Drive.
          If invoked inside a workspace subdirectory without arguments, it will
          automatically sync that subdirectory.

          Positional:
            SUBDIR                  Relative subfolder inside workspace (e.g. 'TUDelft')

          Options:
            -s, --src PATH          Explicit source directory (overrides default workspace root)
            -d, --dest REMOTE:PATH  Explicit destination remote target (overrides default remote)
            -h, --help              Show this help message

          Defaults:
            Source Root:            $DEFAULT_SRC
            Target Remote:          $DEFAULT_REMOTE
            Rclone Config:          $CONFIG

          Any unmatched flags (e.g. --dry-run, -P) are forwarded to rclone.
          EOF
            exit 0
          }

          while [ "$#" -gt 0 ]; do
            case "$1" in
              -h|--help)
                usage
                ;;
              -s|--src)
                SRC_OVERRIDE="$2"
                shift 2
                ;;
              -d|--dest)
                DEST_OVERRIDE="$2"
                shift 2
                ;;
              --)
                shift
                while [ "$#" -gt 0 ]; do
                  EXTRA_ARGS+=("$1")
                  shift
                done
                break
                ;;
              -*)
                EXTRA_ARGS+=("$1")
                shift
                ;;
              *)
                if [ -z "$SUBDIR" ]; then
                  SUBDIR="$1"
                else
                  EXTRA_ARGS+=("$1")
                fi
                shift
                ;;
            esac
          done

          # Auto-detect SUBDIR from $PWD if inside DEFAULT_SRC and not explicitly set
          if [ -z "$SUBDIR" ] && [ -z "$SRC_OVERRIDE" ]; then
            case "$PWD" in
              "$DEFAULT_SRC"/*)
                SUBDIR="''${PWD#"$DEFAULT_SRC"/}"
                ;;
            esac
          fi

          # Resolve source directory
          if [ -n "$SRC_OVERRIDE" ]; then
            SRC="$SRC_OVERRIDE"
          elif [ -n "$SUBDIR" ]; then
            SRC="$DEFAULT_SRC/''${SUBDIR#/}"
          else
            SRC="$DEFAULT_SRC"
          fi

          # Resolve destination target
          if [ -n "$DEST_OVERRIDE" ]; then
            DEST="$DEST_OVERRIDE"
          elif [ -n "$SUBDIR" ]; then
            DEST="$DEFAULT_REMOTE''${SUBDIR#/}"
          else
            DEST="$DEFAULT_REMOTE"
          fi

          if [ ! -d "$SRC" ]; then
            echo "Error: Source directory '$SRC' does not exist." >&2
            exit 1
          fi

          echo "Syncing: $SRC -> $DEST"
          if [ "''${#EXTRA_ARGS[@]}" -gt 0 ]; then
            echo "Forwarding flags: ''${EXTRA_ARGS[*]}"
          fi

          rclone copy "$SRC" "$DEST" \
            --config "$CONFIG" \
            --links \
            --fast-list \
            --filter-from "${excludeFile}" \
            -P \
            ''${EXTRA_ARGS+"''${EXTRA_ARGS[@]}"}

          echo "Upload complete!"
        '';
      })
    ];

    systemd.user.services.rclone-gdrive-mount = {
      Unit = {
        Description = "Automated Rclone Google Drive Mount (FUSE Mode)";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cfg.mountDir}";
        ExecStart =
          "${pkgs.rclone}/bin/rclone mount ${cfg.remoteName}: ${cfg.mountDir} "
          + "--config=${cfg.rcloneConfigFile} "
          + "--rc "
          + "--rc-no-auth "
          + "--links "
          + "--vfs-cache-mode full "
          + "--vfs-cache-max-size 10G "
          + "--vfs-read-chunk-size 32M "
          + "--vfs-read-chunk-size-limit 2G "
          + "--buffer-size 64M "
          + "--dir-cache-time 72h "
          + "--poll-interval 15s "
          + "--allow-non-empty";
        ExecStop = "/run/wrappers/bin/fusermount3 -uz ${cfg.mountDir}";
        Restart = "on-failure";
        RestartSec = "10s";
        Environment = ["PATH=/run/wrappers/bin:$PATH"];
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
