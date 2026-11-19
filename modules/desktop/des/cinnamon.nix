{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.cinnamon;
in {
  options.frost.desktop.des = {
    cinnamon.enable = lib.mkEnableOption "Cinnamon desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.cinnamon.enable = true;
    };
  };
}
