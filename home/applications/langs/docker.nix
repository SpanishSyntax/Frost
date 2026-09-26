{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.docker;
in {
  options.frost.home.apps.langs.docker.enable = lib.mkEnableOption "Docker support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.docker-language-server
      pkgs.docker-compose-language-service
      pkgs.hadolint
    ];
  };
}
