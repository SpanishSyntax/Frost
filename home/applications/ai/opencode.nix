{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.opencode;
in {
  options.frost.home.apps.ai.opencode.enable = lib.mkEnableOption "Opencode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
    ];
    home.sessionVariables = {
      OLLAMA_HOST = "http://void:11434";
      OLLAMA_API_BASE = "http://void:11434";
    };
  };
}
