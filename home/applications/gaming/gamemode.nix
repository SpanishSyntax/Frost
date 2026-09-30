{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.gaming.gamemode;
in {
  options.frost.home.apps.gaming.gamemode.enable = lib.mkEnableOption "Gamemode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gamemode
    ];
  };
}
