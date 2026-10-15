{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.virtualization.docker;
in {
  options.frost.home.apps.system.virtualization.docker.enable = lib.mkEnableOption "Docker support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # And shit
      pkgs.lazydocker
      pkgs.docker-credential-helpers
      pkgs.docker-language-server
      pkgs.docker-compose-language-service
      pkgs.hadolint
    ];
  };
}
