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

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to Antigravity configs for out-of-store symlinking.
        Defaults to global `frost.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity
    ];

    home.file.".gemini/config/mcp_config.json".source =
      if cfg.configsPath != null
      then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/antigravity/mcp_config.json"
      else "${inputs.self}/home/configs/antigravity/mcp_config.json";
  };
}
