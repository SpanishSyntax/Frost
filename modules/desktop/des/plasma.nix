{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.plasma;
in {
  options.frost.desktop.des = {
    plasma.enable = lib.mkEnableOption "KDE Plasma 6 desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
