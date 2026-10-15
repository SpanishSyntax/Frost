{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.graphics.scanning.gnome_scanner;
in {
  options.frost.home.apps.graphics.scanning.gnome_scanner.enable = lib.mkEnableOption "Gnome scanner";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.simple-scan
    ];
  };
}
