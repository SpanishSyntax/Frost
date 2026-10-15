{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.video.netflix;
in {
  options.frost.home.apps.video.netflix.enable = lib.mkEnableOption "Netflix";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.netflix
    ];
  };
}
