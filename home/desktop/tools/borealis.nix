{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.desktop.tools.borealis;
  system = pkgs.stdenv.hostPlatform.system;
  tomlFormat = pkgs.formats.toml {};

  defaultPkg =
    if inputs ? borealis
    then inputs.borealis.packages.${system}.default
    else pkgs.writeShellScriptBin "borealis" "echo 'borealis input missing'; exit 1";

  defaultWallpapers =
    if inputs ? borealis && (inputs.borealis.packages.${system} or {}) ? wallpapers
    then inputs.borealis.packages.${system}.wallpapers
    else null;

  finalSettings =
    lib.recursiveUpdate {
      general = {
        backend = cfg.backend;
        interval = cfg.interval;
        telemetry_interval = cfg.telemetryInterval;
      };
    }
    cfg.settings;

  resolvedDirs =
    (lib.optional (cfg.includeDefaultWallpapers && cfg.wallpapersPackage != null) cfg.wallpapersPackage)
    ++ (lib.optional (cfg.wallpaperDir != null) cfg.wallpaperDir)
    ++ cfg.extraWallpaperDirs;

  dirArgs =
    if resolvedDirs == []
    then "-d ${config.home.homeDirectory}/.local/share/wallpapers"
    else lib.concatMapStringsSep " " (d: "-d ${toString d}") resolvedDirs;
in {
  options.frost.home.desktop.tools.borealis = {
    enable = lib.mkEnableOption "Borealis dynamic atmospheric wallpaper engine";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Borealis package to use.";
    };

    wallpapersPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = defaultWallpapers;
      description = "Optional bundled wallpapers package to index when `includeDefaultWallpapers = true`.";
    };

    includeDefaultWallpapers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to include Borealis's bundled curated wallpapers.";
    };

    wallpaperDir = lib.mkOption {
      type = lib.types.nullOr (lib.types.either lib.types.path lib.types.str);
      default = null;
      description = "Primary wallpaper directory (defaults to bundled wallpapers or ~/.local/share/wallpapers).";
    };

    extraWallpaperDirs = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.path lib.types.str);
      default = [];
      description = "Additional user wallpaper directories to index.";
    };

    backend = lib.mkOption {
      type = lib.types.enum ["awww" "swww" "hyprpaper" "command"];
      default = "awww";
      description = "Wallpaper display backend to use.";
    };

    interval = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Wallpaper rotation interval in seconds.";
    };

    telemetryInterval = lib.mkOption {
      type = lib.types.int;
      default = 900;
      description = "Telemetry refresh interval in seconds.";
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = {};
      description = "Extra TOML settings merged into `~/.config/borealis/borealis.toml` when `manageConfig = false`.";
    };

    manageConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether Home Manager should link `~/.config/borealis` from `configsPath` via `mkSource`.
        When `false`, declarative `settings` are generated into `~/.config/borealis/borealis.toml` if non-empty.
      '';
    };

    systemd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to run the Borealis wallpaper daemon via a systemd user service.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [cfg.package]
      ++ lib.optional (cfg.backend == "awww" && (pkgs ? awww)) pkgs.awww
      ++ lib.optional (cfg.backend == "swww" && (pkgs ? swww)) pkgs.swww;

    xdg.configFile = lib.mkMerge [
      (lib.mkIf cfg.manageConfig {
        "borealis" = {
          source = config.frost.home.environment.mkSource "borealis";
          recursive = true;
        };
      })
      (lib.mkIf (!cfg.manageConfig && cfg.settings != {}) {
        "borealis/borealis.toml".source = tomlFormat.generate "borealis.toml" finalSettings;
      })
    ];

    systemd.user.services.borealis = lib.mkIf cfg.systemd.enable {
      Unit = {
        Description = "Borealis Dynamic Atmospheric Wallpaper Daemon";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        ConditionEnvironment = "!XDG_CURRENT_DESKTOP=GNOME";
      };
      Service = {
        ExecStart = "${cfg.package}/bin/borealis ${dirArgs} -b ${cfg.backend} run";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
