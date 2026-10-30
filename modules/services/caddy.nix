{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.caddy;
in {
  options.frost.services.caddy = {
    enable = lib.mkEnableOption "Caddy web server and reverse proxy";

    user = lib.mkOption {
      type = lib.types.str;
      default = "usurper";
      description = "User account under which Caddy runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group under which Caddy runs.";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/home/${cfg.user}/.config/caddy/Caddyfile";
      description = "Path to the live Caddyfile configuration.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open HTTP (80) and HTTPS (443) ports in the firewall.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.caddy;
      description = "The Caddy package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    # System package availability for CLI management (caddy reload, validate, fmt)
    environment.systemPackages = [cfg.package];

    # Open firewall ports
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [80 443];

    # Impermanence persistence for internal CA certificates and state
    frost.storage.impermanence.directories = [
      "/var/lib/caddy"
    ];

    services.caddy = {
      enable = true;
      package = cfg.package;
      user = cfg.user;
      group = cfg.group;
      configFile = cfg.configFile;
      resume = false;
    };

    # Systemd service overrides to allow:
    # 1. Non-root user (usurper) to bind to privileged ports 80 and 443
    # 2. Reading live user configuration and static sites from /home
    systemd.services.caddy.serviceConfig = {
      ProtectHome = lib.mkForce false;
      AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
      CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
    };
  };
}
