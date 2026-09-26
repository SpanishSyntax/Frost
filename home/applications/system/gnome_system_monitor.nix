{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.gnome_system_monitor;
in {
  options.frost.home.apps.system.gnome_system_monitor.enable = lib.mkEnableOption "Gnome System Monitor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-system-monitor
      pkgs.btop
    ];
  };
}
