{
  config,
  lib,
  ...
}: let
  cfg = config.frost.oci.pgadmin;
  tmpDir = "/var/lib/containers/tmp";
in {
  options.frost.oci.pgadmin = {
    enable = lib.mkEnableOption "pgAdmin 4 web interface";

    dataPath = lib.mkOption {
      type = lib.types.path;
      description = ''
        Absolute host directory path for persistent pgAdmin data.
        Must be writable by UID/GID 5050.
      '';
      example = "/persist/var/lib/pgadmin";
    };

    sopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "SOPS file containing pgadmin credentials.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.pgadmin = lib.mkIf (cfg.sopsFile != null) {
      sopsFile = cfg.sopsFile;
      format = "yaml";
    };

    # Automatically set ownership to 5050:5050 on boot/activation
    systemd.tmpfiles.rules = [
      "d ${toString cfg.dataPath} 0700 5050 5050 -"
    ];

    virtualisation.oci-containers.containers.pgadmin = {
      image = "docker.io/dpage/pgadmin4:latest";
      ports = ["9999:80"];
      volumes = [
        "${toString cfg.dataPath}:/var/lib/pgadmin"
      ];
      environmentFiles = lib.optionals (cfg.sopsFile != null) [
        config.sops.secrets.pgadmin.path
      ];
      environment = {
        TMPDIR = tmpDir;
      };
      extraOptions = ["--add-host=host.docker.internal:host-gateway"];
    };
  };
}
