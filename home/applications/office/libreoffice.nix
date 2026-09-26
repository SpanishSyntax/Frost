{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.libreoffice;
in {
  options.frost.home.apps.office.libreoffice.enable = lib.mkEnableOption "Libreoffice";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice-fresh
    ];
  };
}
