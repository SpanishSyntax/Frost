{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.tools.caelestia;
in {
  options.frost.desktop.tools.caelestia = {
    enable = lib.mkEnableOption "Caelestia system integration";
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="uinput", MODE="0660"
    '';
  };
}
