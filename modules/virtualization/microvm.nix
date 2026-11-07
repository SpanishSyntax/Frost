{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.microvm;
in {
  imports = [
    inputs.microvm.nixosModules.host
  ];

  options.frost.virtualization.microvm = {
    enable = lib.mkEnableOption "Microvm hypervisor host support";

    hostBridge = {
      enable = lib.mkEnableOption "Host NAT bridge with DHCP for MicroVM guests";

      bridgeName = lib.mkOption {
        type = lib.types.str;
        default = "microvm";
        description = "Name of the host bridge network interface.";
      };

      tapPattern = lib.mkOption {
        type = lib.types.str;
        default = "vm-*";
        description = "systemd-networkd wildcard pattern matching guest TAP interfaces.";
      };

      subnet = lib.mkOption {
        type = lib.types.str;
        default = "10.100.0.0/24";
        description = "IPv4 subnet for the MicroVM guest network.";
      };

      gateway = lib.mkOption {
        type = lib.types.str;
        default = "10.100.0.1";
        description = "Host IPv4 address on the bridge interface.";
      };

      prefixLength = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = "Subnet prefix length (e.g. 24 for /24).";
      };

      dhcp = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to run systemd-networkd DHCP server on the bridge.";
        };

        poolOffset = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "DHCP dynamic IP pool start offset.";
        };

        poolSize = lib.mkOption {
          type = lib.types.int;
          default = 50;
          description = "DHCP dynamic IP pool size.";
        };

        dns = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["1.1.1.1" "8.8.8.8"];
          description = "DNS servers announced via DHCP to guest MicroVMs.";
        };
      };
    };

    vms = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to build and enable this MicroVM.";
          };

          autostart = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to start this MicroVM automatically on host boot.";
          };

          restartIfChanged = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to restart the MicroVM service when its configuration changes.";
          };

          config = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
            description = "NixOS configuration for this MicroVM.";
          };

          extraModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
            description = "Additional NixOS modules to include in this MicroVM.";
          };

          specialArgs = lib.mkOption {
            type = lib.types.attrs;
            default = {};
            description = "Additional specialArgs passed to the MicroVM module evaluation.";
          };
        };
      }));
      default = {};
      description = "Declarative MicroVM guests to run on the host.";
    };
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.enable;
    }
    (lib.mkIf cfg.enable (let
      enabledVms = lib.filterAttrs (_name: vm: vm.enable) cfg.vms;
    in {
      microvm.vms =
        lib.mapAttrs (name: vm: {
          inherit (vm) autostart restartIfChanged config extraModules specialArgs;
        })
        enabledVms;

      # Ensure VM state directories exist prior to install-microvm-*.service execution
      system.activationScripts.microvm-dirs = ''
        mkdir -p "${config.microvm.stateDir}"
        chown microvm:kvm "${config.microvm.stateDir}"
        chmod 0775 "${config.microvm.stateDir}"
        ${lib.concatLines (lib.mapAttrsToList (name: _vm: ''
            mkdir -p "${config.microvm.stateDir}/${name}"
            chown microvm:kvm "${config.microvm.stateDir}/${name}"
            chmod 0775 "${config.microvm.stateDir}/${name}"
          '')
          enabledVms)}
      '';

      # Allow microvm hypervisor to access block devices (e.g. ZFS Zvols)
      users.users.microvm.extraGroups = ["disk" "kvm"];
      systemd.services."microvm@".serviceConfig.SupplementaryGroups = ["disk" "kvm"];

      frost.storage.impermanence.directories = lib.mkIf config.frost.storage.impermanence.enable [
        config.microvm.stateDir
      ];
    }))
    (lib.mkIf (cfg.enable && cfg.hostBridge.enable) {
      systemd.network = {
        enable = true;
        netdevs."10-${cfg.hostBridge.bridgeName}" = {
          netdevConfig = {
            Kind = "bridge";
            Name = cfg.hostBridge.bridgeName;
          };
        };

        networks."10-${cfg.hostBridge.bridgeName}" = {
          matchConfig.Name = cfg.hostBridge.bridgeName;
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            DHCPServer = cfg.hostBridge.dhcp.enable;
            IPv4Forwarding = "yes";
          };
          dhcpServerConfig = lib.mkIf cfg.hostBridge.dhcp.enable {
            PoolOffset = cfg.hostBridge.dhcp.poolOffset;
            PoolSize = cfg.hostBridge.dhcp.poolSize;
            EmitDNS = true;
            DNS = cfg.hostBridge.dhcp.dns;
          };
          address = ["${cfg.hostBridge.gateway}/${toString cfg.hostBridge.prefixLength}"];
        };

        networks."11-${cfg.hostBridge.bridgeName}-taps" = {
          matchConfig.Name = cfg.hostBridge.tapPattern;
          networkConfig.Bridge = cfg.hostBridge.bridgeName;
          linkConfig.RequiredForOnline = "no";
        };
      };

      networking = {
        nat = {
          enable = true;
          internalIPs = [cfg.hostBridge.subnet];
        };
        firewall = {
          allowedUDPPorts = lib.optionals cfg.hostBridge.dhcp.enable [67];
          trustedInterfaces = [cfg.hostBridge.bridgeName];
        };
      };
    })
  ];
}
