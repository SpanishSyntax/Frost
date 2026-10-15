{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.graphics.vector.inkscape;
in {
  options.frost.home.apps.graphics.vector.inkscape.enable = lib.mkEnableOption "Inkscape";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.inkscape
    ];
  };
}
