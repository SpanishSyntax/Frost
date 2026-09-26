{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.bluetooth;
in {
  options.frost.hardware = {
    bluetooth.enable = lib.mkEnableOption "Bluetooth feature set";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    # services.blueman.enable = true; # Enables the DBus service blueman needs
  };
}
