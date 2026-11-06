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
    vms = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
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
      microvm.vms = lib.mapAttrs (name: vm: {
        inherit (vm) autostart restartIfChanged config extraModules specialArgs;
      }) enabledVms;

      # Ensure VM state directories exist prior to install-microvm-*.service execution
      system.activationScripts.microvm-dirs = ''
        mkdir -p "${config.microvm.stateDir}"
        chown microvm:kvm "${config.microvm.stateDir}"
        chmod 0775 "${config.microvm.stateDir}"
        ${lib.concatLines (lib.mapAttrsToList (name: _vm: ''
          mkdir -p "${config.microvm.stateDir}/${name}"
          chown microvm:kvm "${config.microvm.stateDir}/${name}"
          chmod 0775 "${config.microvm.stateDir}/${name}"
        '') enabledVms)}
      '';

      frost.storage.impermanence.directories = lib.mkIf config.frost.storage.impermanence.enable [
        config.microvm.stateDir
      ];
    }))
  ];
}
