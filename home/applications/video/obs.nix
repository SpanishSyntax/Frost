{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.video.obs;
in {
  options.frost.home.apps.video.obs.enable = lib.mkEnableOption "OBS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obs-studio
    ];
  };
}
