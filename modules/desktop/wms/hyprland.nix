{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.hyprland;
  iioEnabled = config.frost.hardware.sensors.iio.enable or false;
  polkitEnabled = config.frost.security.auth.polkit.enable or false;
in {
  options.frost.desktop.wms = {
    hyprland = {
      enable = lib.mkEnableOption "Hyprland feature set";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    systemd.user.services = {
      iio-hyprland = lib.mkIf iioEnabled {
        description = "iio-hyprland screen rotation daemon";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.iio-hyprland}/bin/iio-hyprland";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };

      hyprpolkitagent = lib.mkIf polkitEnabled {
        description = "Hyprland Polkit Authentication Agent";
        documentation = ["https://wiki.hyprland.org/Hypr-Ecosystem/hyprpolkitagent/"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    frost.desktop.portals.xdg.sessions.hyprland = ["hyprland"];
  };
}
