{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.gnome_pomodoro;
in {
  options.frost.home.apps.office.gnome_pomodoro.enable = lib.mkEnableOption "Gnome pomodoro";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-solanum
    ];
  };
}
