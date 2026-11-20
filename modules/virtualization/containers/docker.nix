{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.containers.docker;
in {
  options.frost.virtualization.containers = {
    docker = {
      enable = lib.mkEnableOption "Docker feature set";

      enableOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to start `docker.service` unconditionally at boot.
          Set to `false` on workstations/laptops to use systemd socket activation (`docker.socket`),
          avoiding multi-second BuildKit initialization during graphical boot.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      inherit (cfg) enableOnBoot;
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

    frost.system.storage.impermanence.directories = [
      "/var/lib/docker"
    ];
  };
}
