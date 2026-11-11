{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.beacon;
  hasCustomConfig = cfg.dataPath != null || cfg.repoPath != null;
in {
  options.frost.home.apps.icebergs.beacon = {
    enable = lib.mkEnableOption "Beacon AI learning agent harness";

    dataPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "\${config.home.homeDirectory}/Documents/Notes/knowledge";
      description = ''
        Path to store Beacon graph ledgers, nodes, and session data.
        Sets the LH_DATA_DIR environment variable when launching.
        If null, defaults to Beacon's default storage.
      '';
    };

    repoPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "\${config.home.homeDirectory}/beacon";
      description = ''
        Optional path to the beacon repository checkout so the desktop application
        launches seamlessly from any working directory or app launcher.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default =
        if inputs ? beacon
        then inputs.beacon.packages.${pkgs.stdenv.hostPlatform.system}.default
        else pkgs.writeShellScriptBin "beacon" "echo 'beacon flake input not configured'; exit 1";
      description = "The Beacon desktop launcher package.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (if hasCustomConfig then
        pkgs.symlinkJoin {
          name = "beacon-wrapped";
          paths = [
            (pkgs.writeShellScriptBin "beacon" ''
              ${lib.optionalString (cfg.dataPath != null) ''export LH_DATA_DIR="${cfg.dataPath}"''}
              ${lib.optionalString (cfg.repoPath != null) ''export BEACON_REPO="${cfg.repoPath}"''}
              exec ${cfg.package}/bin/beacon "$@"
            '')
            (pkgs.writeShellScriptBin "beacon-dev" ''
              ${lib.optionalString (cfg.dataPath != null) ''export LH_DATA_DIR="${cfg.dataPath}"''}
              ${lib.optionalString (cfg.repoPath != null) ''export BEACON_REPO="${cfg.repoPath}"''}
              exec ${cfg.package}/bin/beacon-dev "$@"
            '')
            cfg.package
          ];
        }
      else
        cfg.package)
    ];

    home.sessionVariables = lib.mkMerge [
      (lib.mkIf (cfg.dataPath != null) {
        LH_DATA_DIR = cfg.dataPath;
      })
      (lib.mkIf (cfg.repoPath != null) {
        BEACON_REPO = cfg.repoPath;
      })
    ];

    xdg.desktopEntries.beacon = lib.mkIf hasCustomConfig {
      name = "Beacon";
      genericName = "AI Learning Harness";
      comment = "An agent harness for learning: adaptive teaching, practice, and a persistent knowledge graph";
      exec = "env ${lib.optionalString (cfg.dataPath != null) "LH_DATA_DIR=${cfg.dataPath} "}${lib.optionalString (cfg.repoPath != null) "BEACON_REPO=${cfg.repoPath} "}${cfg.package}/bin/beacon %U";
      icon = "beacon";
      terminal = false;
      categories = ["Education" "Development"];
      mimeType = ["x-scheme-handler/beacon"];
    };
  };
}
