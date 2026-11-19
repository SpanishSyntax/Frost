{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.peripherals.printing;
in {
  options.frost.hardware.peripherals = {
    printing.enable = lib.mkEnableOption "Printing feature set";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;

    frost.system.storage.impermanence.directories = [
      "/var/lib/cups"
    ];
  };
}
