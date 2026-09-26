{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.engineering.qgis;
in {
  options.frost.home.apps.engineering.qgis.enable = lib.mkEnableOption "QGIS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.qgis
    ];
  };
}
