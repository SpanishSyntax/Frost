{
  config,
  lib,
  linkConfig,
  ...
}: let
  cfg = config.frost.home.apps.ai.mcp_hub;
in {
  options.frost.home.apps.ai.mcp_hub.enable = lib.mkEnableOption "MCP hub";

  config = lib.mkIf cfg.enable {
    xdg.configFile."mcphub" = {
      source = linkConfig "mcphub";
      recursive = true;
    };
  };
}
