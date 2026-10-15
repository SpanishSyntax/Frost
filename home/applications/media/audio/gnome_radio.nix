{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.media.audio.gnome_radio;
in {
  options.frost.home.apps.media.audio.gnome_radio.enable = lib.mkEnableOption "Gnome radio";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.shortwave
    ];
  };
}
