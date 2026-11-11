{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.browsers.firefox;
in {
  options.frost.home.apps.network.browsers.firefox.enable = lib.mkEnableOption "Firefox Browser";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
