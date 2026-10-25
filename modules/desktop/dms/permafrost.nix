{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.desktop.dms.permafrost;
in {
  imports = [
    inputs.astra-airlock.nixosModules.default
  ];

  options.frost.desktop.dms.permafrost.enable =
    lib.mkEnableOption "Permafrost Greeter";

  config = lib.mkIf cfg.enable {
    services.greetd.astraAirlock = {
      enable = true;
      compositor = "cage";
    };

    services.displayManager.defaultSession = "hyprland-uwsm";
  };
}
