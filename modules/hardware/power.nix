{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.power;
in {
  options.frost.hardware.power = {
    enable = lib.mkEnableOption "Power management";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;
  };
}
