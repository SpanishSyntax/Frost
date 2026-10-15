{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.tools.dbeaver;
in {
  options.frost.home.apps.development.tools.dbeaver.enable = lib.mkEnableOption "Dbeaver";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.dbeaver-bin
    ];
  };
}
