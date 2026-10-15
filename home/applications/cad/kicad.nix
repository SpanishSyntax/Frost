{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.engineering.kicad;
in {
  options.frost.home.apps.engineering.kicad.enable = lib.mkEnableOption "Kicad";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kicad
    ];
  };
}
