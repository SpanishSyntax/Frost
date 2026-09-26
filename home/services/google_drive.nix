{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.services.google_drive;

  # Define where you want to actually work fast, and your GDrive target
  localWorkDir = "${config.home.homeDirectory}/Workspace";
  gdriveMountDir = "${config.home.homeDirectory}/GDrive";
in {
  options.frost.home.services = {
    google_drive.enable = lib.mkEnableOption "Google Drive";
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/rclone/.keep".text = "";

    # Ensure both your fast workspace and the mountpoint exist
    home.activation = {
      createGDriveMountDir = config.lib.dag.entryAfter ["writeBoundary"] ''
        mkdir -p ${gdriveMountDir}
        mkdir -p ${localWorkDir}
      '';
    };

    # Include unison package so it's available
    home.packages = [pkgs.unison];

    # Existing Rclone Mount Service
    systemd.user.services.rclone-gdrive-mount = {
      Unit = {
        Description = "Automated Rclone Google Drive Mount (FUSE Mode)";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
        Type = "simple";
        ExecStart =
          "${pkgs.rclone}/bin/rclone mount gdrive: ${gdriveMountDir} "
          + "--config=${config.home.homeDirectory}/.config/rclone/rclone.conf "
          + "--vfs-cache-mode full "
          + "--vfs-cache-max-size 10G "
          + "--vfs-read-chunk-size 32M "
          + "--vfs-read-chunk-size-limit 2G "
          + "--buffer-size 64M "
          + "--dir-cache-time 72h "
          + "--poll-interval 15s "
          + "--allow-non-empty ";
        ExecStop = "/run/wrappers/bin/fusermount3 -u ${gdriveMountDir}";
        Restart = "on-failure";
        RestartSec = "10s";
        Environment = ["PATH=/run/wrappers/bin:$PATH"];
      };
      Install = {WantedBy = ["default.target"];};
    };

    # NEW: Automated Bidirectional Sync Service via Unison
    systemd.user.services.workspace-gdrive-sync = {
      Unit = {
        Description = "Bidirectional Sync between Fast Workspace and GDrive Mount";
        # Crucial: Only sync if the rclone mount is actively running
        After = ["rclone-gdrive-mount.service"];
        Requires = ["rclone-gdrive-mount.service"];
      };

      Service = {
        Type = "simple";
        # -batch means non-interactive (accept non-conflicting changes automatically)
        # -confirmbigdeletes=false keeps it silent unless things go horribly wrong
        ExecStart = 
          "${pkgs.unison}/bin/unison ${localWorkDir} ${gdriveMountDir} "
          + "-batch "
          + "-confirmbigdeletes=false "
          + "-ignore 'Name .venv' "
          + "-ignore 'Name .direnv' "
          + "-ignore 'Name .Trash-*' "
          + "-ignore 'Name __pycache__' "
          + "-ignore 'Name __marimo__' "
          + "-perms 0";
      };
    };

    # NEW: Timer to trigger the sync every 2 minutes
    systemd.user.timers.workspace-gdrive-sync = {
      Unit = {
        Description = "Trigger Unison Sync periodically";
      };
      Timer = {
        OnBootSec = "2m";
        OnUnitActiveSec = "2m"; # Sync interval
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
