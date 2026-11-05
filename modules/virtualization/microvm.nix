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

      frost.storage.impermanence.directories = lib.mkIf config.frost.storage.impermanence.enable [
        config.microvm.stateDir
      ];
    })
  ];
}
