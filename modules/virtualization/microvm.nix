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

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.microvm.packages.${pkgs.system}.microvm
    ];

    microvm.vms = cfg.vms;
  };
}
