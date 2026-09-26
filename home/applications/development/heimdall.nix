{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.heimdall;
in {
  options.frost.home.apps.development.heimdall.enable = lib.mkEnableOption "Heimdall flash utility";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heimdall-gui
    ];
  };
}
