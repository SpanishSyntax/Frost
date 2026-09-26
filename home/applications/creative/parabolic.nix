{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.creative.parabolic;
in {
  options.frost.home.apps.creative.parabolic.enable = lib.mkEnableOption "Youtube downloader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.parabolic
    ];
  };
}
