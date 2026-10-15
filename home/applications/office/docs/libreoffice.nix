{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.docs.libreoffice;
in {
  options.frost.home.apps.office.docs.libreoffice.enable = lib.mkEnableOption "Libreoffice";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice-fresh
    ];
  };
}
