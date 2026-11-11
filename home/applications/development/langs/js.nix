{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.langs.js;
in {
  options.frost.home.apps.development.langs.js.enable = lib.mkEnableOption "JavaScript/TypeScript support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vtsls # Brain
      pkgs.prettierd
    ];
  };
}
