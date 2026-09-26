{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.typst;
in {
  options.frost.home.apps.langs.typst.enable = lib.mkEnableOption "Typst support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tinymist # Brain
      pkgs.typstyle # Janitor
    ];
  };
}
