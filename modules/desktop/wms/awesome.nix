{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.wms.awesome;
in {
  options.frost.desktop.wms.awesome = {
    enable = lib.mkEnableOption "AwesomeWM dynamic X11 window manager";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.awesome.enable = true;
    };
  };
}
