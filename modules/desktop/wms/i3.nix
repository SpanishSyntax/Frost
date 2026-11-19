{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.i3;
  polkitEnabled = config.frost.security.polkit.enable or false;
in {
  options.frost.desktop.wms.i3 = {
    enable = lib.mkEnableOption "i3 tiling X11 window manager";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
    };

    systemd.user.services.i3-polkit-agent = lib.mkIf polkitEnabled {
      description = "i3 Polkit Authentication Agent";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = "I3SOCK";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };
}
