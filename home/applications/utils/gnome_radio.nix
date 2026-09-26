{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_radio;
in {
  options.frost.home.apps.utils.gnome_radio.enable = lib.mkEnableOption "Gnome radio";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.shortwave
    ];
  };
}
