{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.chrome;
in {
  options.frost.home.apps.networking.chrome.enable = lib.mkEnableOption "Google Chrome";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.google-chrome
    ];
  };
}
