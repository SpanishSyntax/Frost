{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.engineering.drawio;
in {
  options.frost.home.apps.engineering.drawio.enable = lib.mkEnableOption "DrawIO";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.drawio
    ];
  };
}
