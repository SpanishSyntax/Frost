{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.mango;
  polkitEnabled = config.frost.security.auth.polkit.enable or false;
in {
  options.frost.desktop.wms.mango = {
    enable = lib.mkEnableOption "Mango (MangoWC) dynamic tiling Wayland compositor (dwl + scenefx)";

    xwayland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable XWayland support for X11 applications under Mango.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mangowc = {
      enable = true;
      package = pkgs.mangowc.override {
        enableXWayland = cfg.xwayland.enable;
      };
    };

    systemd.user.services.mango-polkit-agent = lib.mkIf polkitEnabled {
      description = "Mango Polkit Authentication Agent";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=mango";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    frost.desktop.portals.xdg = {
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
      sessions.mango = ["wlr"];
    };
  };
}
