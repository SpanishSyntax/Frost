{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.graphics.inkscape;
in {
  options.frost.home.apps.graphics.inkscape.enable = lib.mkEnableOption "Inkscape";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.inkscape
    ];
  };
}
