{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.javascript;
in {
  options.frost.home.apps.langs.javascript.enable = lib.mkEnableOption "JavaScript/TypeScript support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vtsls # Brain
    ];
  };
}
