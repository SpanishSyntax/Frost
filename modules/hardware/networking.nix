{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.networking;

  isNetworkd = cfg.backend == "networkd";
  isNM = cfg.backend == "networkmanager";
  isStatic = cfg.staticIp.address != null;

  tailscaleEnabled =
    lib.attrByPath ["frost" "services" "tailscale" "enable"] false config;

  mainInterface =
    if cfg.staticIp.bridge != null
    then cfg.staticIp.bridge
    else cfg.staticIp.interface;

  publicDns = ["1.1.1.2" "8.8.8.8"];
  tailDns = ["100.100.100.100"];

  mkCidr = addr: prefix: "${addr}/${toString prefix}";
in {
  options.frost.hardware.networking = {
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };

    hostId = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "[0-9a-fA-F]{8}");
      default = null;
      example = "4e37bc2c";
      description = "The unique 32-bit host identifier (8 hex characters) for this machine.";
    };

    backend = lib.mkOption {
      type = lib.types.enum ["networkmanager" "networkd"];
      default = "networkmanager";
      description = "Networking backend to use.";
    };

    extraTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      description = "Deprecated: Use frost.security.firewall.extraTCPPorts instead.";
    };

    extraTCPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {type = lib.types.port;};
          to = lib.mkOption {type = lib.types.port;};
        };
      });
      default = [];
      description = "Deprecated: Use frost.security.firewall.extraTCPPortRanges instead.";
    };

    extraUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      description = "Deprecated: Use frost.security.firewall.extraUDPPorts instead.";
    };

    extraUDPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {type = lib.types.port;};
          to = lib.mkOption {type = lib.types.port;};
        };
      });
      default = [];
      description = "Deprecated: Use frost.security.firewall.extraUDPPortRanges instead.";
    };

    panicMode = lib.mkEnableOption "Deprecated: Use frost.security.firewall.panicMode instead.";

    staticIp = {
      address = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      prefixLength = lib.mkOption {
        type = lib.types.int;
        default = 24;
      };

      gateway = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      interface = lib.mkOption {
        type = lib.types.str;
        default = "eno1";
      };

      upstreamNameservers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = publicDns;
      };

      bridge = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      extraBridgeInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };

      tapUser = lib.mkOption {
        type = lib.types.str;
        default = "microvm";
      };

      taps = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            address = lib.mkOption {type = lib.types.str;};
            prefixLength = lib.mkOption {
              type = lib.types.int;
              default = 24;
            };
          };
        });
        default = {};
      };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(isNM && isStatic);
          message = "Static IP configuration requires networkd backend.";
        }
      ];
    }
    ########################################
    # ALWAYS APPLIED
    ########################################
    {
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.ip_forward" = 1;
      };

      networking = {
        hostName = lib.mkDefault cfg.hostname;
        hostId = lib.mkIf (cfg.hostId != null) (lib.mkDefault cfg.hostId);
        enableIPv6 = lib.mkDefault false;
        firewall.trustedInterfaces =
          lib.optional (cfg.staticIp.bridge != null) cfg.staticIp.bridge
          ++ lib.attrNames cfg.staticIp.taps;
      };
    }

    # Backward compatibility forwarding to frost.security.firewall
    (lib.mkIf (cfg.extraTCPPorts != [] || cfg.extraTCPPortRanges != [] || cfg.extraUDPPorts != [] || cfg.extraUDPPortRanges != [] || cfg.panicMode) {
      frost.security.firewall = {
        extraTCPPorts = cfg.extraTCPPorts;
        extraTCPPortRanges = cfg.extraTCPPortRanges;
        extraUDPPorts = cfg.extraUDPPorts;
        extraUDPPortRanges = cfg.extraUDPPortRanges;
        inherit (cfg) panicMode;
      };
    })

    ########################################
    # NetworkManager backend
    ########################################
    (lib.mkIf isNM {
      networking.networkmanager = {
        enable = lib.mkDefault true;
        unmanaged = [
          "microvm"
          "vm-*"
          "docker0"
          "br-*"
          "podman*"
        ];
      };
      systemd.network.enable = lib.mkDefault false;

      frost.storage.impermanence.directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
      ];

      assertions = [
        {
          assertion = cfg.staticIp.bridge == null;
          message = "Bridges require networkd backend.";
        }
        {
          assertion = cfg.staticIp.taps == {};
          message = "TAP interfaces require networkd backend.";
        }
      ];
    })

    ########################################
    # systemd-networkd backend
    ########################################
    (lib.mkIf isNetworkd {
      networking = {
        networkmanager.enable = lib.mkDefault false;
        useDHCP = lib.mkDefault false;
        nat = lib.mkIf (cfg.staticIp.taps != {}) {
          enable = true;
          internalInterfaces = lib.attrNames cfg.staticIp.taps;
          externalInterface = cfg.staticIp.interface;
        };
      };

      services.resolved.enable = lib.mkDefault true;
      systemd.network.enable = lib.mkDefault true;

      systemd.network = {
        netdevs = lib.mkMerge [
          (lib.mkIf (cfg.staticIp.bridge != null) {
            "10-${cfg.staticIp.bridge}" = {
              netdevConfig = {
                Name = cfg.staticIp.bridge;
                Kind = "bridge";
              };
            };
          })
          (lib.mapAttrs' (name: tapCfg:
            lib.nameValuePair "20-${name}" {
              netdevConfig = {
                Name = name;
                Kind = "tap";
              };
              tapConfig.User = cfg.staticIp.tapUser;
            })
          cfg.staticIp.taps)
        ];

        networks = lib.mkMerge [
          # UNIFIED PHYSICAL INTERFACE LOGIC
          {
            "10-${cfg.staticIp.interface}" = {
              matchConfig.Name = cfg.staticIp.interface;
              # Relaxed check to prevent the 'degraded' hang
              linkConfig.RequiredForOnline = "routable";

              networkConfig = lib.mkMerge [
                {
                  IPv4Forwarding = "yes";
                  DHCP =
                    if isStatic
                    then "no"
                    else "yes";
                }
                (lib.mkIf (cfg.staticIp.bridge != null) {Bridge = cfg.staticIp.bridge;})
              ];

              # IP goes here only if NOT bridged
              address = lib.mkIf (isStatic && cfg.staticIp.bridge == null) [
                (mkCidr cfg.staticIp.address cfg.staticIp.prefixLength)
              ];
              gateway =
                lib.mkIf (isStatic && cfg.staticIp.bridge == null && cfg.staticIp.gateway != null)
                [cfg.staticIp.gateway];
              dns =
                lib.mkIf (isStatic && cfg.staticIp.bridge == null)
                (cfg.staticIp.upstreamNameservers ++ lib.optionals tailscaleEnabled tailDns);
            };
          }

          # BRIDGE (IP Owner if it exists)
          (lib.mkIf (isStatic && cfg.staticIp.bridge != null) {
            "20-${cfg.staticIp.bridge}" = {
              matchConfig.Name = cfg.staticIp.bridge;
              address = [(mkCidr cfg.staticIp.address cfg.staticIp.prefixLength)];
              gateway = lib.mkIf (cfg.staticIp.gateway != null) [cfg.staticIp.gateway];
              networkConfig.IPv4Forwarding = "yes";
            };
          })

          # TAPS
          (lib.mapAttrs' (name: tapCfg:
            lib.nameValuePair "30-${name}" {
              matchConfig.Name = name;
              linkConfig.RequiredForOnline = "no";
              networkConfig = lib.mkMerge [
                {IPv4Forwarding = "yes";}
                (lib.mkIf (cfg.staticIp.bridge != null) {Bridge = cfg.staticIp.bridge;})
              ];
              address = lib.mkIf (cfg.staticIp.bridge == null) [
                (mkCidr tapCfg.address tapCfg.prefixLength)
              ];
            })
          cfg.staticIp.taps)

          # Fallback plug-and-play DHCP for any other physical ethernet NICs
          {
            "99-ethernet-default" = {
              matchConfig.Type = "ether";
              networkConfig.DHCP = "yes";
              linkConfig.RequiredForOnline = "no";
            };
          }
        ];
      };
    })
  ];
}
