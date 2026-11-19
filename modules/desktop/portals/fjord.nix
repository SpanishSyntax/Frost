{
  config,
  lib,
  pkgs,
  inputs,
  wrapBin ? null,
  ...
}: let
  cfg = config.frost.desktop.portals.fjord;
  pkg =
    if inputs ? fjord
    then inputs.fjord.packages.${pkgs.stdenv.hostPlatform.system}.default
    else null;
  wrappedPkg =
    if wrapBin != null
    then
      wrapBin pkgs {
        pkg = cfg.package;
        name = "fjord";
        target = "wormhole";
      }
    else cfg.package;
in {
  options.frost.desktop.portals = {
    fjord = {
      enable = lib.mkEnableOption "Fjord Material 3 XDG desktop portal integration";
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkg;
        description = "The Fjord package to use.";
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.package != null) {
    environment.systemPackages = [wrappedPkg];

    systemd.user.services.xdg-desktop-portal-wormhole = {
      overrideStrategy = "asDropin";
      aliases = ["fjord.service"];
    };

    frost.desktop.portals.xdg = {
      enable = lib.mkDefault true;
      extraPortals = [cfg.package];
      portalOrder = ["wormhole"];
      interfaceOverrides = {
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
}
