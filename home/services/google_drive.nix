{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.services.google_drive;

  localWorkDir = "${config.home.homeDirectory}/Workspace";
  gdriveMountDir = "${config.home.homeDirectory}/GDrive";
  rcloneConfig = "${config.home.homeDirectory}/.config/rclone/rclone.conf";
in {
  options.frost.home.services = {
    google_drive.enable = lib.mkEnableOption "Google Drive FUSE Mount";
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/rclone/.keep".text = "";

    # Ensure both your fast workspace and the mountpoint exist
    home.activation = {
      createGDriveDirs = config.lib.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "${localWorkDir}"
        mkdir -p "${gdriveMountDir}"
      '';
    };

    home.packages = [pkgs.rclone];

    # Background FUSE Mount: browse, copy in, or copy out whenever needed
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
          + "--config=${rcloneConfig} "
          + "--vfs-cache-mode full "
          + "--vfs-cache-max-size 10G "
          + "--vfs-read-chunk-size 32M "
          + "--vfs-read-chunk-size-limit 2G "
          + "--buffer-size 64M "
          + "--dir-cache-time 72h "
          + "--poll-interval 15s "
          + "--allow-non-empty";
        ExecStop = "/run/wrappers/bin/fusermount3 -u ${gdriveMountDir}";
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
