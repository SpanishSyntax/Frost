{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.virtualization.docker;
in {
  options.frost.home.apps.virtualization.docker.enable = lib.mkEnableOption "Docker support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # And shit
      pkgs.lazydocker
      pkgs.docker-credential-helpers
    ];
  };
}
