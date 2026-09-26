{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.leisure.anime;
in {
  options.frost.home.apps.leisure.anime.enable = lib.mkEnableOption "Ani CLI";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ani-cli
    ];
  };
}
