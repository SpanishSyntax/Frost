{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.uinput;
in {
  options.frost.hardware.uinput = {
    enable = lib.mkEnableOption "uinput virtual input device";
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="uinput", MODE="0660"
    '';
  };
}
