{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.toml;
in {
  options.frost.home.apps.langs.toml.enable = lib.mkEnableOption "TOML support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.taplo
    ];
  };
}
