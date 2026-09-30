{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.streaming.netflix;
in {
  options.frost.home.apps.streaming.netflix.enable = lib.mkEnableOption "Netflix";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.netflix
    ];
  };
}
