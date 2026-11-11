{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.graphics.raster.gimp;
in {
  options.frost.home.apps.graphics.raster.gimp.enable = lib.mkEnableOption "Gimp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gimp
    ];
  };
}
