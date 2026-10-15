{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs;
  needsPrettier = cfg.js.enable || cfg.yaml.enable || cfg.markdown.enable;
in {
  config = lib.mkIf needsPrettier {
    home.packages = [
      pkgs.prettierd # prettyfier
    ];
  };
}
