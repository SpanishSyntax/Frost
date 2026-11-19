{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  env = config.frost.home.environment;

  mkPureSource = subpath:
    if env.configsPath != null && builtins.isPath env.configsPath
    then
      builtins.path {
        path = env.configsPath + "/${subpath}";
        name = builtins.baseNameOf subpath;
      }
    else "${inputs.self}/configs/home/${subpath}";

  mkImpureSource = subpath:
    if env.configsPath != null && env.mutable && builtins.isString env.configsPath
    then "${env.configsPath}/${subpath}"
    else mkPureSource subpath;

  mkSource = subpath:
    if env.configsPath != null && env.mutable && builtins.isString env.configsPath
    then config.lib.file.mkOutOfStoreSymlink (mkImpureSource subpath)
    else mkPureSource subpath;
in {
  options.frost.home.environment = {
    configsPath = lib.mkOption {
      type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
      default = null;
      example = "\${config.home.homeDirectory}/Glacier/configs/home";
      description = ''
        Global filesystem base path for dotfile configs.
        Set to `null` to use pure flake store starter templates from Frost.
        Set to a string path (e.g. `~/Glacier/configs/home`) for mutable out-of-store symlinks,
        or a Nix path literal (e.g. `../configs/home`) for pure in-store copies.
      '';
    };

    mutable = lib.mkOption {
      type = lib.types.bool;
      default =
        env.configsPath != null
        && builtins.isString env.configsPath;
      description = ''
        Whether dotfile configs should be mutable (live out-of-store symlinking / hot reloading)
        or immutable (pure in-store builds).
        Defaults to true if `configsPath` is a string path, false if it is a Nix path.
      '';
    };

    extraConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["hypr" "waybar" "tut"];
      description = ''
        Extra subdirectories under `configsPath` to link into `~/.config/<name>` via `mkSource`.
        Use this for OS-managed window managers (e.g. `hypr`, `niri`, `sway`) or pure package
        modules that do not ship built-in Frost starter templates.
      '';
    };

    mkPureSource = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      default = mkPureSource;
      description = "Resolve a dotfile subpath to a pure Nix store source path.";
    };

    mkImpureSource = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      default = mkImpureSource;
      description = "Resolve a dotfile subpath to a raw filesystem path when mutable, else pure.";
    };

    mkSource = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      default = mkSource;
      description = "Resolve a dotfile subpath for `xdg.configFile` / `home.file` (out-of-store symlink when mutable, else pure).";
    };
  };

  config = lib.mkIf (env.extraConfigs != []) {
    xdg.configFile = lib.genAttrs env.extraConfigs (name: {
      source = mkSource name;
      recursive = true;
    });
  };
}
