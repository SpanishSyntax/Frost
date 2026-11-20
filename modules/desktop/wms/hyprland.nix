{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.wms.hyprland;
  iioEnabled = config.frost.hardware.sensors.iio.enable or false;
  polkitEnabled = config.frost.security.auth.polkit.enable or false;

  hyprlandIioScript = pkgs.writeShellApplication {
    name = "frost-hyprland-iio";
    runtimeInputs = [
      pkgs.iio-sensor-proxy
      config.programs.hyprland.package
      pkgs.jq
    ];
    text = ''
      OUTPUT="${lib.optionalString (cfg.iioOutput != null) cfg.iioOutput}"
      TABLET_ONLY="${lib.boolToString cfg.iioTabletModeOnly}"

      is_clamshell_laptop_mode() {
        [ "$TABLET_ONLY" != "true" ] && return 1

        # 1. ThinkPad ACPI tablet mode switch (0 = clamshell laptop, 1 = tablet/tent)
        if [ -r /sys/devices/platform/thinkpad_acpi/hotkey_tablet_mode ]; then
          local tb
          tb="$(cat /sys/devices/platform/thinkpad_acpi/hotkey_tablet_mode 2>/dev/null || printf '1')"
          [ "$tb" = "0" ] && return 0
          return 1
        fi

        # 2. Generic IIO hinge angle sensor (< 190 degrees = clamshell laptop mode)
        for dev in /sys/bus/iio/devices/iio:device*; do
          if [ -r "$dev/name" ] && [ "$(cat "$dev/name" 2>/dev/null)" = "hinge" ] && [ -r "$dev/in_angl0_raw" ]; then
            local angle
            angle="$(cat "$dev/in_angl0_raw" 2>/dev/null || printf '360')"
            if [ "$angle" -lt 190 ] 2>/dev/null; then
              return 0
            fi
            return 1
          fi
        done

        return 1
      }

      apply_transform() {
        local requested_transform="$1"
        local target_transform="$requested_transform"

        # In clamshell laptop mode on 2-in-1 convertibles, keep orientation locked to normal (0)
        if is_clamshell_laptop_mode; then
          target_transform=0
        fi

        local monitors_json
        monitors_json="$(hyprctl monitors -j 2>/dev/null || true)"
        [ -z "$monitors_json" ] && return 0

        local mon_info
        if [ -n "$OUTPUT" ]; then
          mon_info="$(printf '%s' "$monitors_json" | jq -r --arg out "$OUTPUT" '.[] | select(.name == $out) | "\(.name)\t\(.transform)\t\(.scale)"' 2>/dev/null | head -n 1 || true)"
        else
          mon_info="$(printf '%s' "$monitors_json" | jq -r '([.[] | select(.name | startswith("eDP"))] + .)[0] // empty | "\(.name)\t\(.transform)\t\(.scale)"' 2>/dev/null | head -n 1 || true)"
        fi
        [ -z "$mon_info" ] && return 0

        local out current_transform current_scale
        IFS=$'\t' read -r out current_transform current_scale <<<"$mon_info"
        [ -z "$out" ] && return 0
        current_scale="''${current_scale:-1}"

        # Skip redundant modesets if the monitor is already at the target transform
        if [ "$current_transform" = "$target_transform" ]; then
          return 0
        fi

        # Prefer Hyprland Lua config eval when active, fall back to legacy keyword parser
        local lua_cmd
        lua_cmd="hl.monitor({ output = \"$out\", transform = $target_transform }); hl.config({ input = { touchdevice = { transform = $target_transform }, tablet = { transform = $target_transform } } })"
        if hyprctl eval "$lua_cmd" 2>/dev/null | grep -qx "ok"; then
          return 0
        fi

        hyprctl --batch "keyword monitor $out,preferred,auto,$current_scale,transform,$target_transform ; keyword input:touchdevice:transform $target_transform ; keyword input:tablet:transform $target_transform" >/dev/null 2>&1 || true
      }

      monitor-sensor --accel | while IFS= read -r line; do
        case "$line" in
          *"orientation changed: normal"*|*"orientation: normal"*)
            apply_transform 0
            ;;
          *"orientation changed: left-up"*|*"orientation: left-up"*)
            apply_transform 1
            ;;
          *"orientation changed: bottom-up"*|*"orientation: bottom-up"*)
            apply_transform 2
            ;;
          *"orientation changed: right-up"*|*"orientation: right-up"*)
            apply_transform 3
            ;;
        esac
      done
    '';
  };
in {
  options.frost.desktop.wms = {
    hyprland = {
      enable = lib.mkEnableOption "Hyprland feature set";

      iioOutput = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "eDP-1";
        description = ''
          Monitor output name to rotate on accelerometer events when `frost.hardware.sensors.iio.enable = true`.
          If `null`, automatically selects the first `eDP-*` display (or primary monitor).
        '';
      };

      iioTabletModeOnly = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          When enabled on 2-in-1 convertibles exposing a tablet-mode switch (`thinkpad_acpi/hotkey_tablet_mode`)
          or IIO `hinge` angle sensor (`in_angl0_raw >= 190°`), only rotate the display when folded into
          tablet/tent/stand mode and keep orientation locked to `normal` (`0`) during normal clamshell laptop use.
          Devices without a tablet switch or hinge sensor always rotate on accelerometer events.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    systemd.user.services = {
      iio-hyprland = lib.mkIf iioEnabled {
        description = "Hyprland IIO screen rotation daemon (Lua & legacy parser compatible)";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${hyprlandIioScript}/bin/frost-hyprland-iio";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };

      hyprpolkitagent = lib.mkIf polkitEnabled {
        description = "Hyprland Polkit Authentication Agent";
        documentation = ["https://wiki.hyprland.org/Hypr-Ecosystem/hyprpolkitagent/"];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    frost.desktop.portals.xdg.sessions.hyprland = ["hyprland"];
  };
}
