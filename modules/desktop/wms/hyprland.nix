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

      resolve_output() {
        if [ -n "$OUTPUT" ]; then
          printf '%s\n' "$OUTPUT"
          return
        fi
        local detected
        detected="$(hyprctl monitors -j | jq -r '([.[] | select(.name | startswith("eDP"))] + .)[0].name // empty')"
        printf '%s\n' "$detected"
      }

      apply_transform() {
        local out="$1"
        local transform="$2"
        [ -z "$out" ] && return 0

        # Prefer Hyprland Lua config eval when active, fall back to legacy keyword parser
        if hyprctl eval "hl.monitor({ output = \"$out\", transform = $transform })" 2>/dev/null | grep -qx "ok"; then
          return 0
        fi
        hyprctl keyword monitor "$out,preferred,auto,auto,transform,$transform" >/dev/null 2>&1 || true
      }

      monitor-sensor --accel | while IFS= read -r line; do
        case "$line" in
          *"orientation changed: normal"*|*"orientation: normal"*)
            apply_transform "$(resolve_output)" 0
            ;;
          *"orientation changed: left-up"*|*"orientation: left-up"*)
            apply_transform "$(resolve_output)" 1
            ;;
          *"orientation changed: bottom-up"*|*"orientation: bottom-up"*)
            apply_transform "$(resolve_output)" 2
            ;;
          *"orientation changed: right-up"*|*"orientation: right-up"*)
            apply_transform "$(resolve_output)" 3
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
