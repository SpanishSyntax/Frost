{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.desktop.wms.hyprland;
in {
  options.frost.desktop.wms = {
    hyprland = {
      enable = lib.mkEnableOption "Hyprland feature set";

      iio = {
        enable = lib.mkEnableOption "iio-hyprland screen rotation support";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # environment.systemPackages = [pkgs.uwsm];
    # systemd.packages = [pkgs.uwsm];
    # environment.pathsToLink = ["/share/uwsm"];
    #
    # services.dbus.implementation = "broker";

    environment.systemPackages = lib.optional cfg.iio.enable inputs.iio-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;

    hardware.sensor.iio.enable = lib.mkIf cfg.iio.enable true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
