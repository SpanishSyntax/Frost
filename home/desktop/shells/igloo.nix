{
  config,
  pkgs,
  lib,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.desktop.shells.igloo;
  cliEnabled = config.frost.home.desktop.tools.igloo_cli.enable or false;
  system = pkgs.stdenv.hostPlatform.system;
  defaultPkg =
    if inputs ? igloo
    then
      if cliEnabled
      then inputs.igloo.packages.${system}.with-cli
      else inputs.igloo.packages.${system}.default
    else pkgs.writeShellScriptBin "caelestia-shell" "echo 'igloo input missing'; exit 1";
  wrappedShell = wrapBin pkgs {
    pkg = cfg.package;
    name = "igloo-shell";
    target = "caelestia-shell";
    hideTarget = false;
  };
in {
  options.frost.home.desktop.shells.igloo = {
    enable = lib.mkEnableOption "Igloo (Caelestia) desktop shell";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Igloo (Caelestia) shell package to use.";
    };

    compositor = lib.mkOption {
      type = lib.types.str;
      default = "hyprland";
      example = "hyprland";
      description = ''
        Target Wayland compositor name for compositor-scoped UWSM environment overrides
        (`~/.config/uwsm/env-<compositor>`), keeping multiple shells isolated across compositors.
      '';
    };

    manageConfig = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether Home Manager should link `~/.config/caelestia` from `configsPath` (or Frost starter configs).
        Set to `false` when managing desktop rices externally via Tapes (`frost.home.apps.settings.desktop.tapes`).
      '';
    };

    manageHyprConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether Home Manager should link `~/.config/hypr` from `configsPath` (e.g. Caelestia Lua Hyprland dots).
        Leave `false` when managing Hyprland configs via Tapes or another compositor.
      '';
    };

    systemd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to autostart the Igloo shell via a systemd user service.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [wrappedShell];

    systemd.user.services.igloo = lib.mkIf cfg.systemd.enable {
      Unit = {
        Description = "Igloo Desktop Shell";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        ConditionEnvironment = "!XDG_CURRENT_DESKTOP=GNOME";
      };
      Service = {
        Type = "exec";
        ExecStart = "${wrappedShell}/bin/igloo-shell";
        Restart = "on-failure";
        RestartSec = "5s";
        TimeoutStopSec = "5s";
        Environment = ["QT_QPA_PLATFORM=wayland"];
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    # Compositor-scoped UWSM environment injection (~/.config/uwsm/env-<compositor>)
    xdg.configFile."uwsm/env-${cfg.compositor}".text = ''
      # 1. Source Home Manager's generated environment variables first
      if [ -f "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh" ]; then
        . "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"
      fi

      # 2. Wayland toolkit backends
      export GDK_BACKEND='wayland,x11'
      export QT_QPA_PLATFORM='wayland;xcb'
      export SDL_VIDEODRIVER='wayland,x11,windows'
      export CLUTTER_BACKEND='wayland'
      export ELECTRON_OZONE_PLATFORM_HINT='auto'
      export _JAVA_AWT_WM_NONREPARENTING='1'

      # 3. Igloo (Caelestia) Qt & Platform overrides
      export QT_QPA_PLATFORMTHEME='qtengine'
      export QT_WAYLAND_DISABLE_WINDOWDECORATION='1'
      export QT_AUTO_SCREEN_SCALE_FACTOR='1'
    '';

    xdg.configFile."caelestia" = lib.mkIf cfg.manageConfig {
      source = config.frost.home.environment.mkSource "caelestia";
      recursive = true;
    };

    xdg.configFile."hypr" = lib.mkIf cfg.manageHyprConfig {
      source = config.frost.home.environment.mkSource "hypr";
      recursive = true;
    };
  };
}
