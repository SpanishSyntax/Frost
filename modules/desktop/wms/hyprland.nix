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
    hyprland.enable = lib.mkEnableOption "Hyprland feature set";
  };

  config = lib.mkIf cfg.enable {
    # environment.systemPackages = [pkgs.uwsm];
    # systemd.packages = [pkgs.uwsm];
    # environment.pathsToLink = ["/share/uwsm"];
    #
    # services.dbus.implementation = "broker";

    environment.systemPackages = with pkgs; [
      inputs.iio-hyprland.packages.${stdenv.hostPlatform.system}.default
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
