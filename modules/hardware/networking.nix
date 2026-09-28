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

    backend = lib.mkOption {
      type = lib.types.enum ["networkmanager" "networkd"];
      default = "networkmanager";
      description = "Networking backend to use.";
    };

    extraTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
    };

    extraTCPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {type = lib.types.port;};
          to = lib.mkOption {type = lib.types.port;};
        };
      });
      default = [];
    };

    extraUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
    };

    extraUDPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {type = lib.types.port;};
          to = lib.mkOption {type = lib.types.port;};
        };
      });
      default = [];
    };

    panicMode = lib.mkEnableOption "Drop most incoming traffic";

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
        hostName = cfg.hostname;
        enableIPv6 = false;
        nftables.enable = true;

        firewall = {
          enable = true;

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

          checkReversePath = "loose";

          trustedInterfaces =
            []
            ++ lib.optionals tailscaleEnabled ["tailscale0"]
            ++ lib.optional (cfg.staticIp.bridge != null) cfg.staticIp.bridge
            ++ lib.attrNames cfg.staticIp.taps;

          allowedTCPPorts = lib.optionals (!cfg.panicMode) (
            cfg.extraTCPPorts
            ++ lib.optionals (config.services.openssh.enable or false)
            config.services.openssh.ports
          );

          allowedTCPPortRanges = lib.optionals (!cfg.panicMode) cfg.extraTCPPortRanges;

          allowedUDPPorts = lib.optionals (!cfg.panicMode) (
            cfg.extraUDPPorts
            ++ lib.optionals tailscaleEnabled
            [config.services.tailscale.port]
          );

          allowedUDPPortRanges = lib.optionals (!cfg.panicMode) cfg.extraUDPPortRanges;
        };
      };
    }

    ########################################
    # NetworkManager backend
    ########################################
    (lib.mkIf isNM {
      networking.networkmanager.enable = true;
      systemd.network.enable = false;

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
        networkmanager.enable = false;
        useDHCP = false;
        nat = {
          enable = true;
          internalInterfaces = lib.attrNames cfg.staticIp.taps;
          externalInterface = cfg.staticIp.interface;
        };
      };

      services.resolved.enable = true;
      systemd.network.enable = true;

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
        ];
      };
    })
  ];
}
