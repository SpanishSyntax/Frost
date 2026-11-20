{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.containers.docker;
in {
  options.frost.virtualization.containers = {
    docker = {
      enable = lib.mkEnableOption "Docker feature set";

      enableOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to start `docker.service` unconditionally at boot.
          Set to `false` on workstations/laptops to use systemd socket activation (`docker.socket`),
          avoiding multi-second BuildKit initialization during graphical boot.
        '';
      };

      autoPrune = {
        enable = lib.mkEnableOption "safe weekly pruning of stale Docker BuildKit cache and dangling images (preserves stopped containers such as Distrobox)";

        dates = lib.mkOption {
          type = lib.types.str;
          default = "weekly";
          description = "Systemd timer schedule (`OnCalendar`) for safe Docker cache pruning.";
        };

        maxAge = lib.mkOption {
          type = lib.types.str;
          default = "168h";
          example = "72h";
          description = "Minimum age of BuildKit cache entries before pruning (e.g. `168h` = 7 days).";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      inherit (cfg) enableOnBoot;
      extraPackages = with pkgs; [
        docker-buildx
      ];
      daemon.settings = {
        # userland-proxy = false;
        ipv6 = false;
      };
    };
    environment.systemPackages = with pkgs; [
      docker-buildx
    ];

    systemd.services.docker-cache-prune = lib.mkIf cfg.autoPrune.enable {
      description = "Prune stale Docker BuildKit cache and dangling images (safe for stopped containers)";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "docker-cache-prune" ''
          set -euo pipefail
          # Only prune if dockerd is already running or socket-activatable
          ${config.virtualisation.docker.package}/bin/docker builder prune -f --filter "until=${cfg.autoPrune.maxAge}"
          ${config.virtualisation.docker.package}/bin/docker image prune -f
        '';
      };
    };

    systemd.timers.docker-cache-prune = lib.mkIf cfg.autoPrune.enable {
      description = "Weekly safe Docker BuildKit cache prune timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = cfg.autoPrune.dates;
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };

    frost.system.storage.impermanence.directories = [
      "/var/lib/docker"
    ];
  };
}
