{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.ui.wms.hyprland;
in {
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          hyprpolkitagent = inputs.hyprpolkitagent.packages.${prev.stdenv.hostPlatform.system}.default;
        })
      ];
    }
  ];

  options.frost.home.ui.wms = {
    hyprland = {
      enable = lib.mkEnableOption "Hyprland feature set";

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
        inputs.hyprpolkitagent.packages.${pkgs.stdenv.hostPlatform.system}.default
      ]
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
          ExecStart = "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

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
