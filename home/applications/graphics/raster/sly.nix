{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.graphics.raster.sly;
in {
  options.frost.home.apps.graphics.raster.sly.enable = lib.mkEnableOption "SLY Image editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sly
    ];
  };
}
