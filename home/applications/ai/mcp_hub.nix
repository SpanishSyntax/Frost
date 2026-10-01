{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.mcp_hub;
  dotfiles = "${config.home.homeDirectory}/Frost/home/configs";
in {
  options.frost.home.apps.ai.mcp_hub.enable = lib.mkEnableOption "MCP hub";

  config = lib.mkIf cfg.enable {
    xdg.configFile."mcphub" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/mcphub";
      recursive = true;
    };
  };
}
