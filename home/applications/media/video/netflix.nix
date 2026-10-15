{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.media.video.netflix;
in {
  options.frost.home.apps.media.video.netflix.enable = lib.mkEnableOption "Netflix";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.netflix
    ];
  };
}
