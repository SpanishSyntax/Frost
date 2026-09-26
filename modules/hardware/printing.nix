{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.printing;
in {
  options.frost.hardware = {
    printing.enable = lib.mkEnableOption "Printing feature set";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
