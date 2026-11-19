{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.xfce;
in {
  options.frost.desktop.des = {
    xfce.enable = lib.mkEnableOption "XFCE feature set";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
    };
  };
}
