{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.java;
in {
  options.frost.home.apps.langs.java.enable = lib.mkEnableOption "Java language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.jdt-language-server # Brain
      pkgs.google-java-format # Janitor
    ];
  };
}
