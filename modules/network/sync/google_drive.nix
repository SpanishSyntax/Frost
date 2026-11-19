{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.network.sync.google_drive;
in {
  options.frost.network.sync.google_drive.enable = lib.mkEnableOption "Google Drive";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rclone
    ];
    programs.fuse.enable = true;
  };
}
