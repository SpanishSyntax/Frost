{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.personalization.xdg;
in {
  options.frost.personalization = {
    xdg.enable = lib.mkEnableOption "Xdg";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
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
