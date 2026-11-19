{
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.containers.podman;
  # Detecta de forma dinámica si Docker está activo en el host actual
  dockerEnabled = config.frost.virtualization.containers.docker.enable or false;
in {
  options.frost.virtualization.containers = {
    podman.enable = lib.mkEnableOption "Podman feature set";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
    };

    virtualisation.containers.containersConf.settings = {
      engine = {
        color = "always";
        log_level = "info";
      };
    };

    frost.system.storage.impermanence.directories = [
      "/var/lib/containers"
    ];
  };
}
