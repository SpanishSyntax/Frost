{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.ly;
in {
  options.frost.desktop.dms.ly = {
    enable = lib.mkEnableOption "Ly TUI display manager";

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      example = {
        animation = "colormix";
        bigclock = "en";
      };
      description = "Settings passed to `services.displayManager.ly.settings` (/etc/ly/config.ini).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.ly = {
      enable = true;
      settings = cfg.settings;
    };
  };
}
