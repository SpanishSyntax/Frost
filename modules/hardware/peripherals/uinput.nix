{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.peripherals.uinput;
in {
  options.frost.hardware.peripherals.uinput = {
    enable = lib.mkEnableOption "uinput virtual input device";
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="uinput", MODE="0660"
    '';
  };
}
