{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.lxqt;
in {
  options.frost.desktop.des = {
    lxqt.enable = lib.mkEnableOption "LXQt desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.lxqt.enable = true;
    };
  };
}
