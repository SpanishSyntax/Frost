{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.leisure.gamemode;
in {
  options.frost.home.apps.leisure.gamemode.enable = lib.mkEnableOption "Gamemode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gamemode
    ];
  };
}
