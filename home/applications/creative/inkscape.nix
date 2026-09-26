{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.creative.inkscape;
in {
  options.frost.home.apps.creative.inkscape.enable = lib.mkEnableOption "Inkscape";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.inkscape
    ];
  };
}
