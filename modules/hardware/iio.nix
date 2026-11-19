{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.iio;
in {
  options.frost.hardware = {
    iio.enable = lib.mkEnableOption "IIO sensor proxy (accelerometer and ambient light sensors)";
  };

  config = lib.mkIf cfg.enable {
    hardware.sensor.iio.enable = true;
  };
}
