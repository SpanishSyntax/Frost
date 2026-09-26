{
  config,
  pkgs,
  linkConfig,
  inputs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.flox;
in {
  options.frost.home.apps.ai.flox = {
    enable = lib.mkEnableOption "Flox";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    home.sessionVariables = {
      FLOX_DISABLE_TELEMETRY = "1";
    };

    xdg.configFile."flox_ollama" = {
      source = linkConfig "flox_ollama";
      recursive = true;
    };
  };
}
