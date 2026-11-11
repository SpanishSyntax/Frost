{
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.oci;
  dockerEnabled = config.frost.virtualization.docker.enable or false;
in {
  options.frost.virtualization = {
    oci.enable = lib.mkEnableOption "oci-containers base engine";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend =
        if dockerEnabled
        then "docker"
        else "podman";
    };

    frost.storage.impermanence.directories = [
      "/var/lib/oci"
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/oci 0755 root root -"
    ];
  };
}
