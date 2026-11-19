{
  config,
  pkgs,
  lib,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.desktop.tools.igloo;
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    inputs.igloo.homeManagerModules.default
  ];

  options.frost.home.desktop.tools.igloo = {
    enable = lib.mkEnableOption "Igloo desktop shell";
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
      source = config.frost.home.environment.mkSource "caelestia";
      recursive = true;
    };
  };
}
