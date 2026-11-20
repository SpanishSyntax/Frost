{
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.stacks.pgadmin;
  tmpDir = "/var/lib/containers/tmp";
in {
  options.frost.virtualization.stacks.pgadmin = {
    enable = lib.mkEnableOption "pgAdmin 4 web interface";

    dataPath = lib.mkOption {
      type = lib.types.path;
      default = /var/lib/pgadmin;
      description = ''
        Host directory path for persistent pgAdmin data.
        Must be writable by UID/GID 5050. Automatically added to Frost impermanence.
      '';
      example = "/var/lib/pgadmin";
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

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to start the pgAdmin container automatically on boot (set `false` on laptops to avoid pulling `docker.service` at boot).";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.frost.virtualization.containers.oci.enable;
        message = "frost.virtualization.stacks.pgadmin requires frost.virtualization.containers.oci.enable = true;";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];

    frost.system.storage.impermanence.directories = [
      (toString cfg.dataPath)
    ];

    sops.secrets.pgadmin = lib.mkIf (cfg.sopsFile != null) {
      sopsFile = cfg.sopsFile;
      format = "yaml";
    };

    # Automatically set ownership to 5050:5050 on boot/activation
    systemd.tmpfiles.rules = [
      "d ${toString cfg.dataPath} 0700 5050 5050 -"
    ];

    virtualisation.oci-containers.containers.pgadmin = {
      inherit (cfg) autoStart;
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
