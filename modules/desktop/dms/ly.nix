{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.ly;
in {
  options.frost.desktop.dms.ly.enable = lib.mkEnableOption "Ly";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      ly = {
        enable = true;
      };
    };
  };
}
