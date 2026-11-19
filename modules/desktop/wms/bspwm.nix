{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.bspwm;
in {
  options.frost.desktop.wms.bspwm = {
    enable = lib.mkEnableOption "bspwm binary space partitioning X11 window manager";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.bspwm.enable = true;
    };

    environment.systemPackages = [pkgs.sxhkd];
  };
}
