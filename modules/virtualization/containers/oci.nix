{
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.containers.oci;
  dockerEnabled = config.frost.virtualization.containers.docker.enable or false;
in {
  options.frost.virtualization.containers = {
    oci.enable = lib.mkEnableOption "oci-containers base engine";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend =
        if dockerEnabled
        then "docker"
        else "podman";
    };

    frost.system.storage.impermanence.directories = [
      "/var/lib/oci"
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/oci 0755 root root -"
    ];
  };
}
