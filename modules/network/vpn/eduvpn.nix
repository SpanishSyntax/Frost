{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.network.vpn.eduvpn;
in {
  options.frost.network.vpn.eduvpn = {
    enable = lib.mkEnableOption "eduVPN system integration";
  };

  config = lib.mkIf cfg.enable {
    # 1. WireGuard kernel support
    boot.kernelModules = ["wireguard"];

    # 2. System-wide tooling and D-Bus integration
    environment.systemPackages = with pkgs; [
      eduvpn-client
      wireguard-tools
    ];

    # 4. Trust inbound packets on virtual tunnel interfaces
    networking.firewall.trustedInterfaces = [
      "wg-eduvpn+"
      "tun-eduvpn+"
    ];

    frost.system.storage.impermanence.directories = [
      "/var/lib/eduvpn-common"
    ];
  };
}
