{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.mcp_hub;
in {
  options.frost.home.apps.ai.mcp_hub = {
    enable = lib.mkEnableOption "MCP hub";

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
    xdg.configFile."mcphub" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/mcphub"
        else "${inputs.self}/home/configs/mcphub";
      recursive = true;
    };
  };
}
