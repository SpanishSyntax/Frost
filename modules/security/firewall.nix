{
  config,
  lib,
  ...
}: let
  cfg = config.frost.security.firewall;
in {
  options.frost.security.firewall = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable declarative firewall management powered by nftables.";
    };

    panicMode = lib.mkEnableOption "Drop all incoming ports and heavily throttle ICMP ping requests";

    checkReversePath = lib.mkOption {
      type = lib.types.enum ["strict" "loose" false];
      default = "loose";
      description = "Reverse path filtering policy. 'loose' is required for Docker, Podman, Tailscale, and MicroVM asymmetric routing.";
    };

    extraTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      description = "List of additional TCP ports to open in the firewall.";
    };

    extraTCPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {type = lib.types.port;};
          to = lib.mkOption {type = lib.types.port;};
        };
      });
      default = [];
      description = "List of additional TCP port ranges to open.";
    };

    extraUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      description = "List of additional UDP ports to open in the firewall.";
    };

    extraUDPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {type = lib.types.port;};
          to = lib.mkOption {type = lib.types.port;};
        };
      });
      default = [];
      description = "List of additional UDP port ranges to open.";
    };

    trustedInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Interfaces whose incoming traffic is completely trusted without packet filtering.";
    };
  };

  config = lib.mkMerge [
    {
      networking.firewall.enable = lib.mkDefault cfg.enable;
    }
    (lib.mkIf cfg.enable (lib.mkMerge [
      {
        networking = {
          nftables.enable = lib.mkDefault true;

          firewall = {
            # Container bridge DNS access (allows Docker, Podman to resolve DNS via host)
            interfaces = {
              "docker0" = {
                allowedUDPPorts = [53];
                allowedTCPPorts = [53];
              };
              "br-*" = {
                allowedUDPPorts = [53];
                allowedTCPPorts = [53];
              };
              "podman*" = {
                allowedUDPPorts = [53];
                allowedTCPPorts = [53];
              };
            };

            pingLimit =
              if cfg.panicMode
              then "1/minute"
              else "10/minute burst 5 packets";

            checkReversePath = cfg.checkReversePath;

            trustedInterfaces = cfg.trustedInterfaces;

            allowedTCPPorts = cfg.extraTCPPorts;
            allowedTCPPortRanges = cfg.extraTCPPortRanges;

            allowedUDPPorts = cfg.extraUDPPorts;
            allowedUDPPortRanges = cfg.extraUDPPortRanges;
          };
        };
      }

      # Panic Mode Override
      (lib.mkIf cfg.panicMode {
        networking.firewall = {
          allowedTCPPorts = lib.mkForce [];
          allowedTCPPortRanges = lib.mkForce [];
          allowedUDPPorts = lib.mkForce [];
          allowedUDPPortRanges = lib.mkForce [];
        };
      })
    ]))
  ];
}
