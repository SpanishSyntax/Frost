{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.gnome_characters;
in {
  options.frost.home.apps.system.gnome_characters.enable = lib.mkEnableOption "Gnome characters";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-characters
    ];
  };
}
