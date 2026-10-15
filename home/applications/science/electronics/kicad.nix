{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.science.electronics.kicad;
in {
  options.frost.home.apps.science.electronics.kicad.enable = lib.mkEnableOption "Kicad";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kicad
    ];
  };
}
