{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms;
in {
  options.frost.desktop.dms = {
    defaultSession = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "hyprland-uwsm";
      description = ''
        Default desktop session for display managers (maps to `services.displayManager.defaultSession`).
        Display managers may set a conditional `lib.mkDefault` only when their paired DE/WM is enabled;
        hosts can explicitly override this to any installed session.
      '';
    };
  };

  config = lib.mkIf (cfg.defaultSession != null) {
    services.displayManager.defaultSession = cfg.defaultSession;
  };
}
