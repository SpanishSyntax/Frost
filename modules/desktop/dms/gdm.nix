{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.gdm;
in {
  options.frost.desktop.dms.gdm.enable = lib.mkEnableOption "GDM";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      gdm = {
        enable = true;
      };
    };
  };
}
