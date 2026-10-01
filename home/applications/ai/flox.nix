{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.flox;
in {
  options.frost.home.apps.ai.flox = {
    enable = lib.mkEnableOption "Flox";
    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to flox configs for out-of-store symlinking.
        Defaults to global `frost.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.sessionVariables = {
      FLOX_DISABLE_TELEMETRY = "1";
    };

    xdg.configFile."flox_ollama" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/flox_ollama"
        else "${inputs.self}/home/configs/flox_ollama";
      recursive = true;
    };
  };
}
