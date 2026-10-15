{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.fastfetch;

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
          width = 36;
          height = 18;
          padding = {
            top = 1;
            left = 2;
            right = 3;
          };
        };

        display = {
          separator = "";
          percent = {
            type = 3; # Renders both numbers and graphical bars globally
          };
          bar = {
            char = {
              elapsed = "■";
              total = "□";
            };
            width = 15;
          };
        };

        # Color Palette Mapping Guide:
        # #89dceb = Frost Cyan
        # #94e2d5 = Polar Mint
        # #b4befe = Glacial Lavender
        # #cdd6f4 = Alpine White
        # #585b70 = Muted Frost Grey

        modules = [
          "break"
          {
            type = "title";
            format = "{##cdd6f4}❄ {user-name}{##585b70}@{##89dceb}{host-name} {##89dceb}";
          }
          "break"
          {
            type = "title";
            format = "{##89dceb}╭───── ABOUT ─────╮";
          }
          {
            type = "os";
            key = "│     Distro      │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "kernel";
            key = "│     kernel      │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "wm";
            key = "│     Desktop     │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "terminal";
            key = "│     Term        │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "shell";
            key = "│     Shell       │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "packages";
            key = "│     Pkgs        │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "uptime";
            key = "│     Uptime      │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "custom";
            format = "{##89dceb}├─── TELEMETRY ───┤";
          }
          {
            type = "cpu";
            key = "│     Cpu         │    ";
            keyColor = "#94e2d5";
            outputColor = "#cdd6f4";
          }
          {
            type = "cpuusage";
            key = "│     Load        │    ";
            keyColor = "#94e2d5";
            outputColor = "#b4befe";
          }
          {
            type = "memory";
            key = "│     Memory      │    ";
            keyColor = "#94e2d5";
            outputColor = "#b4befe";
          }
          {
            type = "disk";
            key = "│     Storage     │    ";
            keyColor = "#94e2d5";
            outputColor = "#b4befe";
          }
          {
            type = "battery";
            key = "│     Power       │    ";
            keyColor = "#94e2d5";
            outputColor = "#b4befe";
          }
          {
            type = "custom";
            format = "{##89dceb}╰─────────────────╯";
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
