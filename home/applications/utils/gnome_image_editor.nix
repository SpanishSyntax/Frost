{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_image_editor;
in {
  options.frost.home.apps.utils.gnome_image_editor.enable = lib.mkEnableOption "Gnome image editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.switcheroo
    ];
  };
}
