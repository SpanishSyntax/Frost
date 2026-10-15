{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.media.video.obs;
in {
  options.frost.home.apps.media.video.obs.enable = lib.mkEnableOption "OBS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obs-studio
    ];
  };
}
