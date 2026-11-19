{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.personalization.xdg;
in {
  options.frost.personalization = {
    xdg = {
      enable = lib.mkEnableOption "XDG user directories and portal management";

      extraPortals = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression "[ pkgs.xdg-desktop-portal-kde ]";
        description = "Extra portal implementations to register with NixOS xdg.portal.";
      };

      portalOrder = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["wormhole"];
        description = "Custom portal backends prioritized ahead of gtk and session-specific fallbacks.";
      };

      interfaceOverrides = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        example = {"org.freedesktop.impl.portal.FileChooser" = "wormhole";};
        description = "Explicit per-interface portal backend bindings merged into registered WM sessions.";
      };

      sessions = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        default = {};
        example = {
          hyprland = ["hyprland"];
          sway = ["wlr"];
        };
        description = ''
          Map of standalone WM session names to their compositor-specific fallback portal(s).
          Generates <session>-portals.conf with `portalOrder ++ ["gtk"] ++ fallbacks` without
          emitting a global `common` portals.conf that would hijack full DEs like GNOME.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = [pkgs.xdg-desktop-portal-gtk] ++ cfg.extraPortals;
      config = lib.mapAttrs (_: fallbacks:
        {
          default = lib.mkOverride 90 (cfg.portalOrder ++ ["gtk"] ++ fallbacks);
        }
        // lib.mapAttrs (_: lib.mkOverride 90) cfg.interfaceOverrides)
      cfg.sessions;
    };
  };
}
