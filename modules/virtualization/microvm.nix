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
    enable = lib.mkEnableOption "Microvm";
    vms = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "MicroVMs to run on the host.";
    };
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.enable;
    }
    (lib.mkIf cfg.enable {
      microvm.vms = cfg.vms;

      # Ensure VM state directories exist prior to install-microvm-*.service execution
      system.activationScripts.microvm-dirs = ''
        mkdir -p "${config.microvm.stateDir}"
        chown microvm:kvm "${config.microvm.stateDir}"
        chmod 0775 "${config.microvm.stateDir}"
        ${lib.concatLines (lib.mapAttrsToList (name: vm: ''
          mkdir -p "${config.microvm.stateDir}/${name}"
          chown microvm:kvm "${config.microvm.stateDir}/${name}"
          chmod 0775 "${config.microvm.stateDir}/${name}"
        '') cfg.vms)}
      '';

      frost.storage.impermanence.directories = lib.mkIf config.frost.storage.impermanence.enable [
        config.microvm.stateDir
      ];
    })
  ];
}
