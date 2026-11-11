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

    guest = {
      optimizations = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Standardized kernel, initrd, and daemon footprint optimizations tailored for headless MicroVM guests:
            - **Minimal Scripted Initrd**: Disables systemd-in-initrd and default host controllers to minimize initrd size and achieve sub-second boot times.
            - **VirtIO Only**: Embeds only necessary virtio modules (pci, blk, balloon, console, net, virtiofs) and root filesystems (ext4, erofs).
            - **Stripped Closure**: Omits documentation, man pages, fontconfig, and command-not-found databases to minimize disk and closure footprint.
            - **Bypassed Blocking Services**: Disables systemd-udev-settle (no dynamic physical hardware to wait on), systemd-oomd, and one-shot catalog updates.
            - **Volatile Journald**: Restricts journal logs to volatile memory (capped at 32MB) to prevent disk I/O thrashing on virtual disks.
          '';
        };
      };
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
            LinkLocalAddressing = "no";
            IPv6AcceptRA = "no";
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
          networkConfig = {
            Bridge = cfg.hostBridge.bridgeName;
            LinkLocalAddressing = "no";
            IPv6AcceptRA = "no";
          };
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
    (lib.mkIf cfg.guest.optimizations.enable {
      # 1. Sub-second boot: Bypass systemd stage-1 initrd in favor of fast scripted initrd
      boot.initrd.systemd.enable = lib.mkDefault false;

      # 2. Prevent bundling hundreds of physical SATA/SCSI/USB drivers into the guest initrd
      boot.initrd.includeDefaultModules = lib.mkDefault false;

      # 3. Embed only virtio hypervisor drivers and guest filesystems
      boot.initrd.kernelModules = [
        "virtio_pci"
        "virtio_blk"
        "virtio_balloon"
        "virtio_console"
        "virtio_net"
        "virtiofs"
        "ext4"
        "erofs"
      ];

      # 4. Strip documentation and font registries for minimal guest image closure
      documentation.enable = lib.mkDefault false;
      documentation.man.enable = lib.mkDefault false;
      documentation.nixos.enable = lib.mkDefault false;
      fonts.fontconfig.enable = lib.mkDefault false;
      programs.command-not-found.enable = lib.mkDefault false;

      # 5. Disable systemd services unneeded in virtualized environments
      systemd.oomd.enable = lib.mkDefault false;
      # udev settle blocks VM boot waiting for hardware that does not exist in a microvm
      systemd.services.systemd-udev-settle.enable = lib.mkDefault false;
      systemd.services.systemd-journal-catalog-update.enable = lib.mkDefault false;
      systemd.services.systemd-update-done.enable = lib.mkDefault false;
      systemd.services.lastlog2-import.enable = lib.mkForce false;

      # 6. Volatile in-memory logs capped at 32MB to protect virtual image wear
      services.journald.extraConfig = ''
        Storage=volatile
        RuntimeMaxUse=32M
      '';
    })
  ];
}
