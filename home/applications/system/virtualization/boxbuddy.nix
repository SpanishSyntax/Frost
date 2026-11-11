{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.virtualization.boxbuddy;
in {
  options.frost.home.apps.system.virtualization.boxbuddy.enable = lib.mkEnableOption "Boxbuddy";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.boxbuddy
    ];
  };
}
