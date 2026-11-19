{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.river;
  polkitEnabled = config.frost.security.auth.polkit.enable or false;
in {
  options.frost.desktop.wms.river = {
    enable = lib.mkEnableOption "River dynamic tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.river-classic.enable = true;

    systemd.user.services.river-polkit-agent = lib.mkIf polkitEnabled {
      description = "River Polkit Authentication Agent";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=river";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    frost.desktop.portals.xdg = {
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
      sessions.river = ["wlr"];
    };
  };
}
