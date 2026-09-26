{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.dbeaver;
in {
  options.frost.home.apps.development.dbeaver.enable = lib.mkEnableOption "Dbeaver";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.dbeaver-bin
    ];
  };
}
