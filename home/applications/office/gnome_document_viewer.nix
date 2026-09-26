{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.gnome_document_viewer;
in {
  options.frost.home.apps.office.gnome_document_viewer.enable = lib.mkEnableOption "Gnome PDF viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.papers
    ];
  };
}
