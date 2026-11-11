{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.science.gis.qgis;
in {
  options.frost.home.apps.science.gis.qgis.enable = lib.mkEnableOption "QGIS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.qgis
    ];
  };
}
