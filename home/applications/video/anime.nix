{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.video.anime;
in {
  options.frost.home.apps.video.anime.enable = lib.mkEnableOption "Ani CLI";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ani-cli
    ];
  };
}
