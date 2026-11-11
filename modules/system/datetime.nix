{
  config,
  lib,
  ...
}: let
  cfg = config.frost.system;
in {
  options.frost.system = {
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      description = "Fallback time zone for the system if dynamic detection fails";
    };
    autoTimezone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable automatic network-based timezone switching (tzupdate)";
    };
  };

  config = {
    # 1. Enable automatic network-based timezone switching (when requested)
    services.tzupdate.enable = cfg.autoTimezone;

    # 2. Base hardware clock anchor
    time.timeZone = lib.mkDefault cfg.timezone;
  };
}
