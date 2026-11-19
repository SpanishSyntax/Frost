{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.niri;
  polkitEnabled = config.frost.security.polkit.enable or false;
in {
  options.frost.desktop.wms.niri = {
    enable = lib.mkEnableOption "Niri scrollable-tiling Wayland compositor";

    xwayland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install xwayland-satellite for X11 application support under Niri.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    environment.systemPackages = lib.optional cfg.xwayland.enable pkgs.xwayland-satellite;

    systemd.user.services.niri-polkit-agent = lib.mkIf polkitEnabled {
      description = "Niri Polkit Authentication Agent";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = "NIRI_SOCKET";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    frost.personalization.xdg = {
      extraPortals = [pkgs.xdg-desktop-portal-gnome];
      sessions.niri = ["gnome"];
    };
  };
}
