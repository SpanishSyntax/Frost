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
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = [pkgs.xdg-desktop-portal-gtk] ++ cfg.extraPortals;
      config = {
        common.default = [
          "hyprland"
          "gtk"
        ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };
}
