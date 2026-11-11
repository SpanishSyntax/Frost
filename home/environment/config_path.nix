{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.frost.home.environment = {
    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "${config.home.homeDirectory}/Glacier/configs/home";
      description = ''
        Global filesystem base path for dotfile configs.
        Set to `null` to use pure flake store starter templates from Frost.
        Set to a path (e.g. ~/Glacier/configs/home or ../configs/home) to enable dotfile configs from your private fleet.
      '';
    };

    mutable = lib.mkOption {
      type = lib.types.bool;
      default =
        config.frost.home.environment.configsPath != null
        && builtins.isString config.frost.home.environment.configsPath;
      description = ''
        Whether dotfile configs should be mutable (live out-of-store symlinking / hot reloading)
        or immutable (pure in-store builds).
        Defaults to true if `configsPath` is a string path, false if it is a Nix path.
      '';
    };

    mkSource = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      default = subpath:
        let
          env = config.frost.home.environment;
        in
          if env.configsPath != null
          then
            if env.mutable && builtins.isString env.configsPath
            then config.lib.file.mkOutOfStoreSymlink "${env.configsPath}/${subpath}"
            else if builtins.isPath env.configsPath
            then builtins.path { path = env.configsPath + "/${subpath}"; name = builtins.baseNameOf subpath; }
            else "${env.configsPath}/${subpath}"
          else "${inputs.self}/configs/home/${subpath}";
      description = ''
        Helper function to resolve dotfile source paths according to global `configsPath` and `mutable`.
      '';
    };
  };
}
