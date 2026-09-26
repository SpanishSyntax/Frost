{
  config,
  pkgs,
  lib,
  inputs,
  linkConfig,
  ...
}: let
  cfg = config.frost.home.ui.tools.caelestia;
in {
  imports = [
    inputs.caelestia.homeManagerModules.default
  ];

  options.frost.home.ui.tools.caelestia = {
    enable = lib.mkEnableOption "caelestia";
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
      source = linkConfig "caelestia";
      recursive = true;
    };
    xdg.configFile."hypr" = {
      source = linkConfig "hypr";
      recursive = true;
    };
  };
}
