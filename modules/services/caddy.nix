{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.caddy;
in {
  options.frost.services.caddy = {
    enable = lib.mkEnableOption "Caddy web server and reverse proxy (hardened system daemon)";

    mutable = lib.mkOption {
      type = lib.types.bool;
      default = config.frost.environment.mutable;
      description = "Whether Caddy should load configuration live from filesystem (mutable) or purely from the Nix store (immutable).";
    };

    configDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = config.frost.environment.mkSource "caddy";
      apply = dir:
        if dir != null && builtins.isPath dir
        then builtins.path { path = dir; name = "caddy-configs"; }
        else dir;
      description = ''
        Directory containing Caddy configuration files (entrypoint and modular imports).
        If provided as a path (e.g. ../../configs/system/caddy), the entire directory
        is copied into the store so multi-file relative imports (e.g. `import conf.d/*`) work.
        Defaults to `frost.environment.mkSource "caddy"` if set.
      '';
    };

    entrypoint = lib.mkOption {
      type = lib.types.str;
      default = "Caddyfile";
      description = "Main entrypoint file inside configDir.";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      apply = file:
        if file != null && builtins.isPath file
        then builtins.path { path = file; name = "Caddyfile"; }
        else file;
      description = "Direct path to a single Caddyfile. Used if configDir is null.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Raw Caddyfile configuration lines to use when both configDir and configFile are null.";
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
    # System package availability for CLI management (caddy validate, fmt)
    environment.systemPackages = [cfg.package];

    # Open firewall ports
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [80 443];

    systemd.tmpfiles.rules = [
      "d /var/www/sites 2775 caddy users - -"
    ];

    # Impermanence persistence for internal CA certificates and ACME state
    frost.storage.impermanence.directories = [
      "/var/lib/caddy"
    ];

    # Hardened systemd daemon running under dedicated caddy:caddy user
    # ProtectHome=true is enforced by default in upstream NixOS services.caddy
    services.caddy = {
      enable = true;
      package = cfg.package;
      configFile = lib.mkIf (cfg.configDir != null || cfg.configFile != null) (
        if cfg.configDir != null
        then "${cfg.configDir}/${cfg.entrypoint}"
        else cfg.configFile
      );
      extraConfig = lib.mkIf (cfg.configDir == null && cfg.configFile == null) (
        if cfg.extraConfig != ""
        then cfg.extraConfig
        else builtins.readFile ../../configs/system/caddy/Caddyfile
      );
      resume = false;
    };
  };
}
