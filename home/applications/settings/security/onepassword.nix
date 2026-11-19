{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.settings.security.onepassword;
in {
  options.frost.home.apps.settings.security.onepassword = {
    enable = lib.mkEnableOption "1Password autostart daemon";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      onepassword = {
        Unit = {
          Description = "1Password Password Manager";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target" "hyprpolkitagent.service"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };
    };
  };
}
