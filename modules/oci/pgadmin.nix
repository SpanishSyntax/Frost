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

    port = lib.mkOption {
      type = lib.types.port;
      default = 9999;
      description = "Host HTTP port for pgAdmin.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open the pgAdmin port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];

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
      ports = ["${toString cfg.port}:80"];
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
