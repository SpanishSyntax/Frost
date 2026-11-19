{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.mate;
in {
  options.frost.desktop.des = {
    mate.enable = lib.mkEnableOption "MATE desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.mate.enable = true;
    };
  };
}
