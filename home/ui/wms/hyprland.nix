{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.ui.wms.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpolkitagent
    ];

    systemd.user.services = {
      # Polkit Agent for 1Password / auth prompts
      hyprpolkitagent = {
        Unit = {
          Description = "Hyprland Polkit Authentication Agent";
          Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hyprpolkitagent/";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

      # Sensor listener for screen rotation
      iio-hyprland = {
        Unit = {
          Description = "iio-hyprland screen rotation daemon";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.iio-hyprland}/bin/iio-hyprland";
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
