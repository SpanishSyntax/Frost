{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.yaml;
in {
  options.frost.home.apps.langs.yaml.enable = lib.mkEnableOption "YAML support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.yaml-language-server
    ];
  };
}
