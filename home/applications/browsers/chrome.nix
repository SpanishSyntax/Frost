{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.browsers.chrome;
in {
  options.frost.home.apps.browsers.chrome.enable = lib.mkEnableOption "Google Chrome";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.google-chrome
    ];
  };
}
