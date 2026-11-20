{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.hardware.sensors.wluma;
  tomlFormat = pkgs.formats.toml {};

  staticConfigDir = pkgs.runCommand "wluma-xdg-config" {} ''
    mkdir -p "$out/wluma"
    ln -s ${tomlFormat.generate "wluma-config.toml" cfg.settings} "$out/wluma/config.toml"
  '';

  wlumaWrapper = pkgs.writeShellApplication {
    name = "frost-wluma";
    runtimeInputs = [
      cfg.package
      pkgs.coreutils
    ];
    text = ''
      USER_CFG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
      if [ -f "$USER_CFG_HOME/wluma/config.toml" ]; then
        exec wluma
      fi

      ${
        if cfg.settings != {}
        then ''
          export XDG_CONFIG_HOME="${staticConfigDir}"
          exec wluma
        ''
        else ''
          RUNTIME_CFG_HOME="''${XDG_RUNTIME_DIR:-/tmp}/frost-wluma"
          mkdir -p "$RUNTIME_CFG_HOME/wluma"
          CFG_FILE="$RUNTIME_CFG_HOME/wluma/config.toml"

          BACKLIGHT_PATH="/sys/class/backlight/intel_backlight"
          OUTPUT_NAME="eDP-1"
          for bl in /sys/class/backlight/*; do
            if [ -e "$bl" ]; then
              REAL_BL="$(readlink -f "$bl" 2>/dev/null || printf '%s' "$bl")"
              parent_drm="$(basename "$(dirname "$REAL_BL")")"
              case "$parent_drm" in
                card*-*)
                  OUTPUT_NAME="''${parent_drm#card*-}"
                  ;;
              esac
              BACKLIGHT_PATH="$bl"
              break
            fi
          done

          cat >"$CFG_FILE" <<EOF
          [als.iio]
          path = "/sys/bus/iio/devices"
          thresholds = { 0 = "night", 20 = "dark", 80 = "dim", 250 = "normal", 500 = "bright", 800 = "outdoors" }

          [[output.backlight]]
          name = "$OUTPUT_NAME"
          path = "$BACKLIGHT_PATH"
          capturer = "${cfg.capturer}"
          EOF

          ${lib.optionalString cfg.keyboardBacklight ''
            for kbd in /sys/bus/platform/devices/*/leds/*::kbd_backlight; do
              if [ -d "$kbd" ]; then
                kbd_name="keyboard-$(basename "$kbd" | cut -d: -f1)"
                cat >>"$CFG_FILE" <<EOF

          [[keyboard]]
          name = "$kbd_name"
          path = "$kbd"
          EOF
                break
              fi
            done
          ''}

          export XDG_CONFIG_HOME="$RUNTIME_CFG_HOME"
          exec wluma
        ''
      }
    '';
  };
in {
  options.frost.hardware.sensors.wluma = {
    enable = lib.mkEnableOption "wluma Wayland automatic brightness daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wluma;
      description = "The wluma package to use.";
    };

    capturer = lib.mkOption {
      type = lib.types.enum [
        "none"
        "wayland"
        "ext-image-copy-capture-v1"
        "wlr-screencopy-unstable-v1"
        "wlr-export-dmabuf-unstable-v1"
      ];
      default = "none";
      description = ''
        Screen content capturer backend for `wluma`.
        Defaults to `"none"` (pure IIO ambient light sensor adaptive brightness), which avoids
        continuous Wayland DMA-BUF screencopy GPU/RAM overhead and prevents Hyprland EGL
        renderbuffer segfaults during screen rotation or modesetting.
      '';
    };

    keyboardBacklight = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether wluma should also auto-discover and manage platform keyboard backlights (`*::kbd_backlight`).";
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = {};
      description = ''
        Optional explicit TOML configuration written to `/etc/xdg/wluma/config.toml`.
        When empty, Frost auto-generates a runtime `config.toml` targeting the detected
        `/sys/class/backlight/*` device with `capturer = config.frost.hardware.sensors.wluma.capturer`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    frost.hardware.sensors.iio.enable = lib.mkDefault true;

    environment.systemPackages = [cfg.package];

    # Allow the active seat user and `video` group to write sysfs backlight brightness
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness", TAG+="uaccess"
      ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness", TAG+="uaccess"
    '';

    environment.etc."xdg/wluma/config.toml" = lib.mkIf (cfg.settings != {}) {
      source = tomlFormat.generate "wluma-config.toml" cfg.settings;
    };

    systemd.user.services.wluma = {
      description = "wluma automatic Wayland display brightness daemon";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = [
        "WAYLAND_DISPLAY"
        "!XDG_CURRENT_DESKTOP=GNOME"
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${wlumaWrapper}/bin/frost-wluma";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
