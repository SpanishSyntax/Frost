{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.settings.desktop.tapes;
  system = pkgs.stdenv.hostPlatform.system;

  defaultPkg =
    if inputs ? tapes
    then
      if cfg.buildFromSource && (inputs.tapes.packages.${system} ? tapes)
      then inputs.tapes.packages.${system}.tapes
      else inputs.tapes.packages.${system}.default
    else pkgs.writeShellScriptBin "tapes" "echo 'tapes input missing'; exit 1";

  defaultGuiPkg =
    if inputs ? tapes-deck
    then
      if cfg.buildFromSource && (inputs.tapes-deck.packages.${system} ? tapes-deck)
      then inputs.tapes-deck.packages.${system}.tapes-deck
      else inputs.tapes-deck.packages.${system}.default
    else pkgs.writeShellScriptBin "tapes-deck" "echo 'tapes-deck input missing'; exit 1";

  featuredNames =
    if inputs ? featured-tapes && (inputs.featured-tapes.lib or {}) ? riceNames
    then inputs.featured-tapes.lib.riceNames
    else [];
in {
  imports = lib.optional (inputs ? featured-tapes) inputs.featured-tapes.homeManagerModules.default;

  options.frost.home.apps.settings.desktop.tapes = {
    enable = lib.mkEnableOption "Tapes v2 atomic per-target dotfile switcher";

    buildFromSource = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Force compiling `tapes` and `tapes-deck` locally from source instead of using
        the prebuilt `autoPatchelfHook` release binaries (which automatically fall back
        to source when the flake version is ahead of the pinned release or on non-x86_64).
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Tapes CLI package to use.";
    };

    gui = {
      enable = lib.mkEnableOption "Tapes-Deck official GUI for Tapes";

      package = lib.mkOption {
        type = lib.types.package;
        default = defaultGuiPkg;
        description = "The Tapes-Deck GUI package to use.";
      };
    };

    featured = lib.mkOption {
      type =
        if featuredNames != []
        then lib.types.listOf (lib.types.enum featuredNames)
        else lib.types.listOf lib.types.str;
      default = [];
      example = ["nebula" "noctalia-libre"];
      description = ''
        Curated featured tapes from `featured-tapes` to materialize declaratively into `~/.tapes/<name>`
        along with all of their Nix runtime packages, fonts, and QML plugins.
      '';
    };

    localTapes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["niri-noctalia" "sway-minimal"];
      description = ''
        Opt-in user-authored tapes under `<configsPath>/tapes/<name>` to symlink into `~/.tapes/<name>`
        via `mkSource` (mutable out-of-store directory symlink when `configsPath` is a string, so both
        `tapes-deck` and runtime theming tools can write to them). Leave empty to keep custom tapes
        untracked directly inside `~/.tapes/`.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages =
        [cfg.package]
        ++ lib.optional cfg.gui.enable cfg.gui.package;
    }
    (lib.mkIf (inputs ? featured-tapes && cfg.featured != []) {
      programs.featured-tapes = {
        enable = true;
        tapes = cfg.featured;
      };
    })
    (lib.mkIf (cfg.localTapes != []) {
      home.file = lib.listToAttrs (map (name: {
          name = ".tapes/${name}";
          value.source = config.frost.home.environment.mkSource "tapes/${name}";
        })
        cfg.localTapes);
    })
  ]);
}
