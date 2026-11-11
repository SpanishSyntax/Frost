{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.services.google_drive;
in {
  options.frost.services.google_drive.enable = lib.mkEnableOption "Google Drive";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rclone
    ];
    programs.fuse.enable = true;
  };
}
