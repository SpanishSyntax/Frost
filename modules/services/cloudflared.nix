{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.cloudflared;
in {
  options.frost.services.cloudflared = {
    role = lib.mkOption {
      type = lib.types.enum ["none" "client" "server"];
      default = "none";
      description = "Cloudflared role: server (tunnel), client (CLI), or none.";
    };

    tunnelId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The specific Cloudflare Tunnel UUID for this machine.";
    };

    credentialsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the specific tunnel credentials file.";
    };

    defaultService = lib.mkOption {
      type = lib.types.str;
      default = "http_status:404";
      description = "The default fallback service if no ingress rules match.";
    };
  };

  config = lib.mkMerge [
    # 🖥️ Server → run tunnel daemon dynamically
    (lib.mkIf (cfg.role == "server") {
      assertions = [
        {
          assertion = cfg.tunnelId != "" && cfg.credentialsFile != null;
          message = "You must specify `frost.services.cloudflared.tunnelId` and `frost.services.cloudflared.credentialsFile` when role is set to 'server'.";
        }
      ];

      sops.secrets."${cfg.tunnelId}" = {
        sopsFile = cfg.credentialsFile;
        format = "json";
        owner = "root";
        group = "root";
        mode = "0444";
        path = "/run/secrets/${cfg.tunnelId}";
      };

      services.cloudflared = {
        enable = true;
        tunnels = {
          "${cfg.tunnelId}" = {
            credentialsFile = "/run/secrets/${cfg.tunnelId}";
            default = cfg.defaultService;
          };
        };
      };
    })

    # 💻 Client → install CLI only
    (lib.mkIf (cfg.role == "client") {
      environment.systemPackages = [pkgs.cloudflared];
    })
  ];
}
