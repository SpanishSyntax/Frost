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
    manageConfig = lib.mkEnableOption "linking ~/.config/flox_ollama from configsPath";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.sessionVariables = {
      FLOX_DISABLE_TELEMETRY = "1";
    };

    xdg.configFile."flox_ollama" = lib.mkIf cfg.manageConfig {
      source = config.frost.home.environment.mkSource "flox_ollama";
      recursive = true;
    };
  };
}
