{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_calendar;
in {
  options.frost.home.apps.utils.gnome_calendar.enable = lib.mkEnableOption "Gnome calendar";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-calendar
    ];
  };
}
