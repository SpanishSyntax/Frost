{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.services.onepassword;
in {
  options.frost.home.services.onepassword = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.frost.home.ui.wms.hyprland.enable;
      description = "Enable 1password (defaults to true when Hyprland is enabled).";
    };
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
