{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.libvirt;
in {
  options.frost.virtualization = {
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
    };

    # Force-disable the monolithic service & socket
    systemd.services.libvirtd.enable = false;
    systemd.sockets.libvirtd.enable = false;
    systemd.sockets."libvirtd-ro".enable = false;
    systemd.sockets."libvirtd-admin".enable = false;

    # Enable the modular sockets instead
    systemd.sockets = {
      "virtqemud".wantedBy = ["sockets.target"];
      "virtnetworkd".wantedBy = ["sockets.target"];
      "virtnodedevd".wantedBy = ["sockets.target"];
      "virtstoraged".wantedBy = ["sockets.target"];
      "virtsecretd".wantedBy = ["sockets.target"];
      "virtnwfilterd".wantedBy = ["sockets.target"];
    };
  };
}
