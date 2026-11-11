{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.n8n;
in {
  options.frost.home.apps.ai.n8n.enable = lib.mkEnableOption "N8N";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.n8n
      pkgs.node-red
    ];
  };
}
