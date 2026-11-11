{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.gnome_fretboard;
in {
  options.frost.home.apps.utility.accessories.gnome_fretboard.enable = lib.mkEnableOption "Gnome fretboard";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fretboard
    ];
  };
}
