{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.cosmic;
in {
  options.frost.desktop.des = {
    cosmic.enable = lib.mkEnableOption "System76 COSMIC desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;
  };
}
