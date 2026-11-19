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

    manageConfig = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether Home Manager should link Antigravity `~/.gemini` configs from `configsPath` (or Frost starter configs).";
    };
  };

  config = lib.mkIf cfg.enable (let
    mkSource = sub: config.frost.home.environment.mkSource "antigravity/${sub}";
  in {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity
    ];

    home.file = lib.mkIf cfg.manageConfig {
      ".gemini/config/mcp_config.json".source = mkSource "mcp_config.json";
      ".gemini/config/GEMINI.md".source = mkSource "GEMINI.md";
      ".gemini/config/skills".source = mkSource "skills";
      ".gemini/config/agents".source = mkSource "agents";
      ".gemini/antigravity-cli/settings.json".source = mkSource "settings.json";
    };
  });
}
