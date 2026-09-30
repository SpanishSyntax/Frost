{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.streaming.anime;
in {
  options.frost.home.apps.streaming.anime.enable = lib.mkEnableOption "Ani CLI";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ani-cli
    ];
  };
}
