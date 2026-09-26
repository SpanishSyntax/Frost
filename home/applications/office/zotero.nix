{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.zotero;
in {
  options.frost.home.apps.office.zotero.enable = lib.mkEnableOption "zotero";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zotero
    ];
  };
}
