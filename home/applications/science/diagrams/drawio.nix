{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.science.diagrams.drawio;
in {
  options.frost.home.apps.science.diagrams.drawio.enable = lib.mkEnableOption "DrawIO";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.drawio
    ];
  };
}
