{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_image_viewer;
in {
  options.frost.home.apps.utils.gnome_image_viewer.enable = lib.mkEnableOption "Gnome image viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.loupe
    ];
  };
}
