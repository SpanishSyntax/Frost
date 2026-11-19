{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.sensors.iio;
in {
  options.frost.hardware.sensors = {
    iio.enable = lib.mkEnableOption "IIO sensor proxy (accelerometer and ambient light sensors)";
  };

  config = lib.mkIf cfg.enable {
    hardware.sensor.iio.enable = true;
  };
}
