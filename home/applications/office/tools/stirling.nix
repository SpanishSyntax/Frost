{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.stirling;
in {
  options.frost.home.apps.office.tools.stirling.enable = lib.mkEnableOption "Stirling";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.stirling-pdf-desktop
    ];
  };
}
