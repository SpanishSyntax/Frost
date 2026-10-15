{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.langs.yaml;
in {
  options.frost.home.apps.development.langs.yaml.enable = lib.mkEnableOption "YAML support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.yaml-language-server
      pkgs.prettierd
    ];
  };
}
