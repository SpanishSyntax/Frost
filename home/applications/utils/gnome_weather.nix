{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_weather;
in {
  options.frost.home.apps.utils.gnome_weather.enable = lib.mkEnableOption "Gnome weather";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-weather
    ];
  };
}
