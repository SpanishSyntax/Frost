{
  config,
  pkgs,
  lib,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.desktop.shells.igloo;
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    inputs.igloo.homeManagerModules.default
  ];

  options.frost.home.desktop.shells.igloo = {
    enable = lib.mkEnableOption "Igloo (Caelestia) desktop shell";

    compositor = lib.mkOption {
      type = lib.types.str;
      default = "hyprland";
      example = "hyprland";
      description = ''
        Target Wayland compositor name for compositor-scoped UWSM environment overrides
        (`~/.config/uwsm/env-<compositor>`), keeping multiple shells isolated across compositors.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      package = wrapBin pkgs {
        pkg = inputs.igloo.packages.${system}.with-cli;
        name = "igloo-shell";
        target = "caelestia-shell";
        hideTarget = false;
      };
      cli = {
        enable = true;
        package = wrapBin pkgs {
          pkg = inputs.igloo.inputs.caelestia-cli.packages.${system}.default;
          name = "igloo";
          target = "caelestia";
          hideTarget = false;
        };
      };
      systemd.enable = false;
    };

    home.packages = with pkgs; [
      cliphist
      wl-clipboard
      fuzzel
      ydotool
      hyprpicker
      hyprcursor
    ];

    # Compositor-scoped UWSM environment injection (~/.config/uwsm/env-<compositor>)
    xdg.configFile."uwsm/env-${cfg.compositor}".text = ''
      # 1. Source Home Manager's generated environment variables first
      if [ -f "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh" ]; then
        . "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"
      fi

      # 2. Igloo (Caelestia) Qt & Platform overrides
      export QT_QPA_PLATFORMTHEME='qtengine'
      export QT_WAYLAND_DISABLE_WINDOWDECORATION='1'
      export QT_AUTO_SCREEN_SCALE_FACTOR='1'
    '';

    xdg.configFile."caelestia" = {
      source = config.frost.home.environment.mkSource "caelestia";
      recursive = true;
    };
  };
}
