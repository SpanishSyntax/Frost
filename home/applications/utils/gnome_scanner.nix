{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_scanner;
in {
  options.frost.home.apps.utils.gnome_scanner.enable = lib.mkEnableOption "Gnome scanner";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.simple-scan
    ];
  };
}
