{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.system.core.usbutils;
in {
  options.frost.home.apps.system.core.usbutils = {
    enable = lib.mkEnableOption "USB utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.usbutils
    ];
  };
}
