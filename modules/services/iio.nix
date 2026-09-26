{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.iio;
in {
  options.frost.services = {
    iio.enable = lib.mkEnableOption "IIO feature set";
  };

  config = lib.mkIf cfg.enable {
  hardware.sensor.iio.enable = true;
  };
}
