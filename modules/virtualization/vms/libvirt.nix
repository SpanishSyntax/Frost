{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.vms.libvirt;
in {
  options.frost.virtualization.vms = {
    libvirt.enable = lib.mkEnableOption "Libvirt feature set";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };

    frost.system.storage.impermanence.directories = [
      "/var/lib/libvirt"
    ];
  };
}
