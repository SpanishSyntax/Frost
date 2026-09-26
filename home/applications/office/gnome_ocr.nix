{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.gnome_ocr;
in {
  options.frost.home.apps.office.gnome_ocr.enable = lib.mkEnableOption "Gnome OCR";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-frog
    ];
  };
}
