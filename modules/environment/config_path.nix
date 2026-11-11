{
  config,
  lib,
  inputs ? null,
  ...
}: {
  options.frost.environment = {
    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = ../../configs/system;
      description = ''
        Global filesystem base path or flake directory path for OS/system daemon configs.
        Set to `null` by default. Fleets can point this to their system config directory
        (e.g. Glacier/configs/system) so system services can auto-discover their modular config directories.
      '';
    };

    mutable = lib.mkOption {
      type = lib.types.bool;
      default =
        config.frost.environment.configsPath != null
        && builtins.isString config.frost.environment.configsPath;
      description = ''
        Whether system daemon configs should be mutable (live out-of-store symlinking)
        or immutable (pure in-store builds).
        Defaults to true if `configsPath` is a string path (filesystem), false if it is a Nix path (store).
      '';
    };

    mkSource = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      default = subpath:
        let
          env = config.frost.environment;
        in
          if env.configsPath != null
          then
            if env.mutable && builtins.isString env.configsPath
            then "${env.configsPath}/${subpath}"
            else if builtins.isPath env.configsPath
            then builtins.path { path = env.configsPath + "/${subpath}"; name = builtins.baseNameOf subpath; }
            else "${env.configsPath}/${subpath}"
          else
            if inputs != null && inputs ? self && builtins.pathExists "${inputs.self}/configs/system/${subpath}"
            then "${inputs.self}/configs/system/${subpath}"
            else null;
      description = ''
        Helper function to resolve system daemon config paths according to global `configsPath` and `mutable`.
      '';
    };
  };
}
