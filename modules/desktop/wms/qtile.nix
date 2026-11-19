{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.wms.qtile;
in {
  options.frost.desktop.wms.qtile = {
    enable = lib.mkEnableOption "Qtile Python tiling window manager";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
