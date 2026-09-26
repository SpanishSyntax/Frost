{
  config,
  lib,
  ...
}: let
  cfg = config.frost.oci.jellyfin;
  tmpDir = "/var/lib/containers/tmp";
in {
  options.frost.oci.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin";
    publishedServerUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The published server URL for Jellyfin (optional override).";
    };
    sopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "SOPS file containing jellyfin-url secret.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets.jellyfin-url = lib.mkIf (cfg.sopsFile != null && cfg.publishedServerUrl == null) {
      sopsFile = cfg.sopsFile;
      format = "yaml";
    };

    sops.templates."jellyfin.env" = lib.mkIf (cfg.sopsFile != null && cfg.publishedServerUrl == null) {
      content = ''
        JELLYFIN_PublishedServerUrl=${config.sops.placeholder.jellyfin-url}
      '';
    };

    virtualisation.oci-containers.containers.jellyfin = {
      image = "docker.io/jellyfin/jellyfin:latest";
      autoStart = true;
      autoRemoveOnStop = false;
      environmentFiles = lib.optionals (cfg.sopsFile != null && cfg.publishedServerUrl == null) [
        config.sops.templates."jellyfin.env".path
      ];
      ports = [
        "8096:8096/tcp"
        "7359:7359/udp"
      ];
      environment = {
        TMPDIR = tmpDir;
      } // lib.optionalAttrs (cfg.publishedServerUrl != null) {
        JELLYFIN_PublishedServerUrl = cfg.publishedServerUrl;
      };
      volumes = [
        "/mnt/services/jellyfin/config:/config"
        "/mnt/services/jellyfin/cache:/cache"
        "/mnt/services/jellyfin/media:/media"
        "/mnt/services/jellyfin/media2:/media2:ro"
        "/mnt/services/jellyfin/fonts:/usr/local/share/fonts/custom:ro"
      ];
      extraOptions = [
        "--restart=unless-stopped"
      ];
    };
  };
}
