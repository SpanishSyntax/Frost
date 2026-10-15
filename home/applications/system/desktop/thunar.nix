{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.desktop.thunar;
in {
  options.frost.home.apps.system.desktop.thunar.enable = lib.mkEnableOption "thunar";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.thunar
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
    ];
  };
}
