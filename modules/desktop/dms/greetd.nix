{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.desktop.dms.greetd;
  sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions";
  tuigreetCmd = lib.concatStringsSep " " (
    [
      "${pkgs.tuigreet}/bin/tuigreet"
      "--time"
      "--remember"
      "--remember-session"
      "--sessions"
      sessions
    ]
    ++ cfg.extraArgs
  );
in {
  options.frost.desktop.dms.greetd = {
    enable = lib.mkEnableOption "greetd minimal login manager";

    greeter = lib.mkOption {
      type = lib.types.enum ["tuigreet" "regreet" "custom"];
      default = "tuigreet";
      description = "Greeter frontend to launch under greetd.";
    };

    command = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "agreety --cmd bash";
      description = "Custom greeter command when `greeter = \"custom\"`.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["--asterisks" "--greeting" "Welcome to Frost"];
      description = "Extra CLI arguments passed to tuigreet.";
    };

    regreetSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Settings passed to `programs.regreet.settings` when `greeter = \"regreet\"`.";
    };

    regreetCssFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''config.frost.system.runtime.environment.mkSource "regreet/regreet.css"'';
      description = "Optional CSS file for styling ReGreet (loaded via `programs.regreet.extraCss`).";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.greeter == "tuigreet") {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = tuigreetCmd;
          user = "greeter";
        };
      };

      frost.system.storage.impermanence.directories = [
        {
          directory = "/var/cache/tuigreet";
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
      ];
    })

    (lib.mkIf (cfg.greeter == "regreet") {
      programs.regreet = {
        enable = true;
        settings = cfg.regreetSettings;
        extraCss = lib.mkIf (cfg.regreetCssFile != null) (builtins.readFile cfg.regreetCssFile);
      };

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.cage}/bin/cage -s -- ${lib.getExe config.programs.regreet.package}";
          user = "greeter";
        };
      };

      frost.system.storage.impermanence.directories = [
        {
          directory = "/var/cache/regreet";
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
      ];
    })

    (lib.mkIf (cfg.greeter == "custom") {
      assertions = [
        {
          assertion = cfg.command != null;
          message = "frost.desktop.dms.greetd.command must be set when greeter = \"custom\".";
        }
      ];

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = cfg.command;
          user = "greeter";
        };
      };
    })
  ]);
}
