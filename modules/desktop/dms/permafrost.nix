{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.desktop.dms.permafrost;
  pkg =
    if inputs ? permafrost
    then inputs.permafrost.packages.${pkgs.stdenv.hostPlatform.system}.default
    else null;
in {
  options.frost.desktop.dms.permafrost = {
    enable = lib.mkEnableOption "PermaFrost Material 3 display manager greeter";
    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkg;
      description = "The PermaFrost greeter package to use.";
    };
    compositor = lib.mkOption {
      type = lib.types.enum ["cage" "hyprland"];
      default = "cage";
      description = "The Wayland compositor to run the greeter in.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.package != null) {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command =
          if cfg.compositor == "cage"
          then "${pkgs.cage}/bin/cage -s -- ${cfg.package}/bin/astra-airlock >/dev/null 2>&1"
          else "${pkgs.hyprland}/bin/Hyprland >/dev/null 2>&1";
        user = "greeter";
      };
    };

    frost.desktop.dms.defaultSession =
      lib.mkIf (config.frost.desktop.wms.hyprland.enable or false) (lib.mkDefault "hyprland-uwsm");

    systemd.tmpfiles.rules = [
      "d /var/cache/astra-airlock 0755 greeter greeter -"
    ];

    frost.system.storage.impermanence.directories = [
      {
        directory = "/var/cache/astra-airlock";
        user = "greeter";
        group = "greeter";
        mode = "0755";
      }
    ];
  };
}
