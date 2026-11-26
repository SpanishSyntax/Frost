{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.vms.libvirt;
in {
  options.frost.virtualization.vms.libvirt = {
    enable = lib.mkEnableOption "Libvirt feature set";

    usbRedirection.enable = lib.mkEnableOption "SPICE USB redirection for guests";

    runAsRoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run libvirt QEMU processes as root instead of an unprivileged user.";
    };

    dbus.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable D-Bus support for libvirtd.";
    };

    nss = {
      enable = lib.mkEnableOption "Libvirt NSS hostname resolution on the host";

      enableGuest = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Resolve guest-reported hostnames in addition to libvirt DHCP leases.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      dbus.enable = cfg.dbus.enable;
      nss = {
        enable = cfg.nss.enable;
        enableGuest = cfg.nss.enableGuest;
      };
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = cfg.runAsRoot;
        swtpm.enable = true;
      };
    };

    virtualisation.spiceUSBRedirection.enable = cfg.usbRedirection.enable;

    frost.system.storage.impermanence.directories = [
      "/var/lib/libvirt"
    ];
  };
}
