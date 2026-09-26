{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.rss;
in {
  options.frost.home.apps.utils.rss.enable = lib.mkEnableOption "RSS Client";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fluent-reader
    ];
  };
}
