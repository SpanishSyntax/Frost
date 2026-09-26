{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.docker;
in {
  options.frost.virtualization = {
    docker.enable = lib.mkEnableOption "Docker feature set";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      extraPackages = with pkgs; [
        docker-buildx
      ];
      daemon.settings = {
        # userland-proxy = false;
        ipv6 = false;
      };
    };
    environment.systemPackages = with pkgs; [
      docker-buildx
    ];
  };
}
