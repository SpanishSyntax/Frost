{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.fastfetch;

  # Compile assets/logo.svg directly into a high-DPI transparent PNG at build time
  frostBadge =
    pkgs.runCommand "frost-badge.png" {
      nativeBuildInputs = [pkgs.resvg];
    } ''
      resvg -w 512 -h 512 ${inputs.self}/assets/logo.svg $out
    '';
in {
  options.frost.home.apps.system.shell.fastfetch = {
    enable = lib.mkEnableOption "Hyper-dense Frost Fastfetch HUD with native Kitty graphics";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo = {
          type = "kitty-direct";
          source = "${frostBadge}";
          width = 26;
          height = 13;
          padding = {
            top = 1;
            left = 2;
            right = 3;
          };
        };

        display = {
          separator = " ";
          constants = [
            "\u001b[38;2;137;220;235m" # $1: Frost Cyan (#89dceb)
            "\u001b[38;2;148;226;213m" # $2: Polar Mint (#94e2d5)
            "\u001b[38;2;180;190;254m" # $3: Glacial Lavender (#b4befe)
            "\u001b[38;2;205;214;244m" # $4: Alpine White (#cdd6f4)
            "\u001b[38;2;88;91;112m" # $5: Muted Frost Grey (#585b70)
          ];
          percent = {
            type = 9; # Renders custom filled gauge blocks [■■■■□□□□]
          };
          bar = {
            char = {
              elapsed = "■";
              total = "□";
            };
            width = 15;
          };
        };

        modules = [
          "break"
          {
            type = "title";
            format = "{$1}╭─ ❄ {$4}{user-name} {$5}at {$1}{host-name} {$1}──────────────────────────────────╮";
          }
          {
            type = "os";
            key = "{$1}│ {$2}󱄅 distro    ";
            format = "{$4}{name} {version-id}";
          }
          {
            type = "kernel";
            key = "{$1}│ {$2}󰌽 kernel    ";
            format = "{$4}{release} {$5}({arch})";
          }
          {
            type = "wm";
            key = "{$1}│ {$2} desktop   ";
            format = "{$4}{name} {$5}[Hyprland/Wayland]";
          }
          {
            type = "terminal";
            key = "{$1}│ {$2} term      ";
            format = "{$4}{name} {$5}[GPU Accel]";
          }
          {
            type = "shell";
            key = "{$1}│ {$2}󰞷 shell     ";
            format = "{$4}{pretty-name} {$5}{version}";
          }
          {
            type = "packages";
            key = "{$1}│ {$2} pkgs      ";
            format = "{$4}{all} {$5}(nix-store)";
          }
          {
            type = "uptime";
            key = "{$1}│ {$2}󰅐 uptime    ";
            format = "{$4}{days}d {hours}h {minutes}m";
          }
          {
            type = "custom";
            format = "{$1}├─ 󰻠 HARDWARE TELEMETRY ─────────────────────────────────────┤";
          }
          {
            type = "cpu";
            key = "{$1}│ {$2}󰻠 cpu       ";
            format = "{$4}{name} {$5}({cores-logical}T @ {freq-max})";
          }
          {
            type = "cpuusage";
            key = "{$1}│ {$2}󱐋 load      ";
            format = "{$3}{bar} {$4}{percentage}";
          }
          {
            type = "memory";
            key = "{$1}│ {$2}󰍛 memory    ";
            format = "{$3}{bar} {$4}{percentage} {$5}({used} / {total})";
          }
          {
            type = "disk";
            key = "{$1}│ {$2}󰋊 storage   ";
            format = "{$3}{bar} {$4}{percentage} {$5}({used} / {total})";
          }
          {
            type = "battery";
            key = "{$1}│ {$2}󰂄 power     ";
            format = "{$3}{bar} {$4}{percentage} {$5}[{status}]";
          }
          {
            type = "custom";
            format = "{$1}╰─────────────────────────────────────── ◈ ◈ ◈ ◈ ◈ ◈ ◈ ◈ ────╯";
          }
          {
            type = "colors";
            paddingLeft = 2;
            symbol = "diamond";
          }
          "break"
        ];
      };
    };
  };
}
