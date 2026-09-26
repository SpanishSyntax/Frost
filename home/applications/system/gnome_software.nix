{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.gnome_software;
in {
  options.frost.home.apps.system.gnome_software.enable = lib.mkEnableOption "Gnome software";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-software
    ];
  };
}
