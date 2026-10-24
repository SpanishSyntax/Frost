{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.learnharness;
  hasCustomConfig = cfg.dataPath != null || cfg.repoPath != null;
in {
  options.frost.home.apps.ai.learnharness = {
    enable = lib.mkEnableOption "LearnHarness AI learning agent harness";

    dataPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "\${config.home.homeDirectory}/Workspace/Notes/knowledge";
      description = ''
        Path to store LearnHarness graph ledgers, nodes, and session data.
        Sets the LH_DATA_DIR environment variable when launching.
        If null, defaults to LearnHarness's default storage.
      '';
    };

    repoPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "\${config.home.homeDirectory}/Documents/learnharness";
      description = ''
        Optional path to the learnharness repository checkout so the desktop application
        launches seamlessly from any working directory or app launcher.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default =
        if inputs ? learnharness
        then inputs.learnharness.packages.${pkgs.stdenv.hostPlatform.system}.default
        else pkgs.writeShellScriptBin "learnharness" "echo 'learnharness flake input not configured'; exit 1";
      description = "The LearnHarness desktop launcher package.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (if hasCustomConfig then
        pkgs.symlinkJoin {
          name = "learnharness-wrapped";
          paths = [
            (pkgs.writeShellScriptBin "learnharness" ''
              ${lib.optionalString (cfg.dataPath != null) ''export LH_DATA_DIR="${cfg.dataPath}"''}
              ${lib.optionalString (cfg.repoPath != null) ''export LEARNHARNESS_REPO="${cfg.repoPath}"''}
              exec ${cfg.package}/bin/learnharness "$@"
            '')
            (pkgs.writeShellScriptBin "learnharness-dev" ''
              ${lib.optionalString (cfg.dataPath != null) ''export LH_DATA_DIR="${cfg.dataPath}"''}
              ${lib.optionalString (cfg.repoPath != null) ''export LEARNHARNESS_REPO="${cfg.repoPath}"''}
              exec ${cfg.package}/bin/learnharness-dev "$@"
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
        LEARNHARNESS_REPO = cfg.repoPath;
      })
    ];

    xdg.desktopEntries.learnharness = lib.mkIf hasCustomConfig {
      name = "LearnHarness";
      genericName = "AI Learning Harness";
      comment = "An agent harness for learning: adaptive teaching, practice, and a persistent knowledge graph";
      exec = "env ${lib.optionalString (cfg.dataPath != null) "LH_DATA_DIR=${cfg.dataPath} "}${lib.optionalString (cfg.repoPath != null) "LEARNHARNESS_REPO=${cfg.repoPath} "}${cfg.package}/bin/learnharness %U";
      icon = "learnharness";
      terminal = false;
      categories = ["Education" "Development"];
      mimeType = ["x-scheme-handler/learnharness"];
    };
  };
}
