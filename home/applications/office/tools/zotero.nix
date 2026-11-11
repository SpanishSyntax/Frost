{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.zotero;
in {
  options.frost.home.apps.office.tools.zotero.enable = lib.mkEnableOption "zotero";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zotero
    ];
  };
}
