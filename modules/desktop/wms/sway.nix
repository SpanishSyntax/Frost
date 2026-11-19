{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.sway;
  iioEnabled = config.frost.hardware.iio.enable or false;
  polkitEnabled = config.frost.security.polkit.enable or false;
in {
  options.frost.desktop.wms.sway = {
    enable = lib.mkEnableOption "Sway tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    systemd.user.services = {
      sway-polkit-agent = lib.mkIf polkitEnabled {
        description = "Sway Polkit Authentication Agent";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "SWAYSOCK";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
        };
      };

      sway-rot8 = lib.mkIf iioEnabled {
        description = "Sway IIO screen rotation daemon (rot8)";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "SWAYSOCK";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.rot8}/bin/rot8";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };

    frost.personalization.xdg = {
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
      sessions.sway = ["wlr"];
    };
  };
}
