{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.creative.obs;
in {
  options.frost.home.apps.creative.obs.enable = lib.mkEnableOption "OBS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obs-studio
    ];
  };
}
