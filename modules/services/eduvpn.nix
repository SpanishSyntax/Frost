{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.eduvpn;
in {
  options.frost.services.eduvpn = {
    enable = lib.mkEnableOption "eduVPN system integration";
  };

  config = lib.mkIf cfg.enable {
    # NixOS built-in module handles systemd services, polkit, and D-Bus interfaces
    programs.eduvpn.enable = true;

    # Kernel driver required for in-kernel WireGuard tunnels
    boot.kernelModules = ["wireguard"];

    # Utilities needed if NetworkManager is absent or for userspace routing
    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];

    # Trust incoming tunnel traffic on interfaces spawned by eduVPN
    networking.firewall.trustedInterfaces = [
      "wg-eduvpn+"
      "tun-eduvpn+"
    ];
  };
}
