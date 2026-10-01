{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.ui.tools.caelestia;
in {
  imports = [
    inputs.caelestia.homeManagerModules.default
  ];

  options.frost.home.ui.tools.caelestia = {
    enable = lib.mkEnableOption "caelestia";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to flox configs for out-of-store symlinking.
        Defaults to global `frost.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      cli.enable = true;
      # ydotool.enable = true;
      systemd = {
        enable = false;
      };
    };
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
      fuzzel
      ydotool
      hyprpicker
      hyprcursor
    ];

    # UWSM Environment Injection
    # Stated here: https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/
    xdg.configFile."uwsm/env".text = ''
      # 1. Source Home Manager's generated environment variables first
      if [ -f "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh" ]; then
        . "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"
      fi

      # 2. Caelestia Qt & Platform overrides
      export QT_QPA_PLATFORMTHEME='qtengine'
      export QT_WAYLAND_DISABLE_WINDOWDECORATION='1'
      export QT_AUTO_SCREEN_SCALE_FACTOR='1'
    '';

    xdg.configFile."caelestia" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/caelestia"
        else "${inputs.self}/home/configs/caelestia";
      recursive = true;
    };
    xdg.configFile."hypr" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/hypr"
        else "${inputs.self}/home/configs/hypr";
      recursive = true;
    };
    xdg.configFile."hyprtoolkit" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/hyprtoolkit"
        else "${inputs.self}/home/configs/hyprtoolkit";
      recursive = true;
    };
  };
}
