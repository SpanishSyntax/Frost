{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_fretboard;
in {
  options.frost.home.apps.utils.gnome_fretboard.enable = lib.mkEnableOption "Gnome fretboard";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fretboard
    ];
  };
}
