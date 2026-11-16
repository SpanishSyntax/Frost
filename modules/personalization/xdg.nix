{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.personalization.xdg;
in {
  imports = [
    inputs.fjord.nixosModules.default
  ];

  options.frost.personalization = {
    xdg = {
      enable = lib.mkEnableOption "XDG user directories and portal management";

      extraPortals = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression "[ pkgs.xdg-desktop-portal-kde ]";
        description = "Extra portal implementations to register with NixOS xdg.portal.";
      };

      fjord = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Fjord (Wormhole) Material 3 desktop portal delegation.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fjord.enable = cfg.fjord.enable;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = [pkgs.xdg-desktop-portal-gtk] ++ cfg.extraPortals;
      config = {
        common.default =
          if cfg.fjord.enable
          then [
            "wormhole"
            "hyprland"
            "gtk"
          ]
          else [
            "hyprland"
            "gtk"
          ];
        hyprland =
          {
            default =
              if cfg.fjord.enable
              then [
                "wormhole"
                "hyprland"
                "gtk"
              ]
              else [
                "gtk"
                "hyprland"
              ];
          }
          // lib.optionalAttrs cfg.fjord.enable {
            "org.freedesktop.impl.portal.ScreenCast" = "wormhole";
            "org.freedesktop.impl.portal.Screenshot" = "wormhole";
            "org.freedesktop.impl.portal.FileChooser" = "wormhole";
            "org.freedesktop.impl.portal.AppChooser" = "wormhole";
            "org.freedesktop.impl.portal.Access" = "wormhole";
            "org.freedesktop.impl.portal.DynamicLauncher" = "wormhole";
            "org.freedesktop.impl.portal.Wallpaper" = "wormhole";
          };
      };
    };
  };
}
