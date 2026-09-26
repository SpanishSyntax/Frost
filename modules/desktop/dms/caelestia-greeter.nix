{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.desktop.dms.caelestia-greeter;
in {
  imports = [
    inputs.astra-airlock.nixosModules.default
  ];

  options.frost.desktop.dms.caelestia-greeter.enable =
    lib.mkEnableOption "Caelestia Greeter";

  config = lib.mkIf cfg.enable {
    services.greetd.astraAirlock = {
      enable = true;
      compositor = "cage";
    };

    services.displayManager.defaultSession = "hyprland-uwsm";
  };
}
