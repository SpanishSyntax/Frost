{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.browsers.firefox;
in {
  options.frost.home.apps.browsers.firefox.enable = lib.mkEnableOption "Firefox Browser";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
