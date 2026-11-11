{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.antigravity;
in {
  options.frost.home.apps.ai.antigravity = {
    enable = lib.mkEnableOption "Google Antigravity";
  };

  config = lib.mkIf cfg.enable (let
    mkSource = sub: config.frost.home.environment.mkSource "antigravity/${sub}";
  in {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity
    ];

    home.file.".gemini/config/mcp_config.json".source = mkSource "mcp_config.json";
    home.file.".gemini/config/GEMINI.md".source = mkSource "GEMINI.md";
    home.file.".gemini/config/skills".source = mkSource "skills";
    home.file.".gemini/config/agents".source = mkSource "agents";
    home.file.".gemini/antigravity-cli/settings.json".source = mkSource "settings.json";
  });
}
