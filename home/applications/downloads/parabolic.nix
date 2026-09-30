{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.downloads.parabolic;
in {
  options.frost.home.apps.downloads.parabolic.enable = lib.mkEnableOption "Youtube downloader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.parabolic
    ];
  };
}
