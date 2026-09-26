{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.xfce;
in {
  options.frost.desktop.des = {
    xfce.enable = lib.mkEnableOption "Gnome feature set";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.xfce.enable = true;
  };
}
