{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.gnome_files;
in {
  options.frost.home.apps.system.gnome_files.enable = lib.mkEnableOption "Gnome files";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nautilus
    ];
  };
}
