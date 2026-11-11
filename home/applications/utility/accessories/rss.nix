{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.rss;
in {
  options.frost.home.apps.utility.accessories.rss.enable = lib.mkEnableOption "RSS Client";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fluent-reader
    ];
  };
}
