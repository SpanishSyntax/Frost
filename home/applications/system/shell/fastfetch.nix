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
    enable = lib.mkEnableOption "Clean Frost Fastfetch HUD with native Kitty graphics";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo = {
          type = "kitty-direct";
          source = "${frostBadge}";
          width = 32;
          height = 16;
          padding = {
            top = 1;
            left = 2;
            right = 4;
          };
        };

        display = {
          separator = "  ";
          key = {
            width = 14;
          };
          percent = {
            type = 3;
          };
          bar = {
            char = {
              elapsed = "■";
              total = "□";
            };
            width = 12;
          };
        };

        modules = [
          "break"
          {
            type = "title";
            format = "{##cdd6f4}❄ {user-name}{##585b70}@{##89dceb}{host-name}";
          }
          {
            type = "custom";
            format = "{##585b70}──────────────────────────────────";
          }
          {
            type = "os";
            key = "{##89dceb}  distro";
          }
          {
            type = "kernel";
            key = "{##89dceb}󰌽  kernel";
          }
          {
            type = "wm";
            key = "{##89dceb}  desktop";
          }
          {
            type = "terminal";
            key = "{##89dceb}󰞷  term";
          }
          {
            type = "shell";
            key = "{##89dceb}󰞧  shell";
          }
          {
            type = "packages";
            key = "{##89dceb}󰏓  packages";
          }
          {
            type = "uptime";
            key = "{##89dceb}󱑎  uptime";
          }
          "break"
          {
            type = "cpu";
            key = "{##94e2d5}  cpu";
          }
          {
            type = "cpuusage";
            key = "{##94e2d5}󰓅  load";
          }
          {
            type = "memory";
            key = "{##94e2d5}󰘚  memory";
          }
          {
            type = "disk";
            key = "{##94e2d5}󰋊  storage";
          }
          {
            type = "battery";
            key = "{##94e2d5}󱐋  power";
          }
          "break"
          {
            type = "colors";
            paddingLeft = 0;
            symbol = "circle";
          }
          "break"
        ];
      };
    };
  };
}
