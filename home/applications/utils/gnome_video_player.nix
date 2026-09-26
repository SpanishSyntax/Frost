{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_video_player;
in {
  options.frost.home.apps.utils.gnome_video_player.enable = lib.mkEnableOption "Gnome video player";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.showtime
    ];
  };
}
