{
  pkgs,
  config,
  lib,
  osConfig ? null,
  ...
}: let
  cfg = config.frost.home.desktop.wms.hyprland;
in {
  options.frost.home.desktop.wms = {
    hyprland = {
      enable = lib.mkEnableOption "Hyprland feature set";

      iio = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default =
            if osConfig != null && (osConfig ? frost.desktop.wms.hyprland.iio.enable)
            then osConfig.frost.desktop.wms.hyprland.iio.enable
            else false;
          defaultText = lib.literalExpression "osConfig.frost.desktop.wms.hyprland.iio.enable or false";
          description = "Enable iio-hyprland screen rotation daemon.";
        };
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression "[ pkgs.wl-clipboard pkgs.waybar ]";
        description = "Extra packages to install alongside Hyprland.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        pkgs.hyprpolkitagent
      ]
      ++ lib.optional cfg.iio.enable pkgs.iio-hyprland
      ++ cfg.extraPackages;

    systemd.user.services = {
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

      iio-hyprland = lib.mkIf cfg.iio.enable {
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
