{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.network.vpn.openvpn;
in {
  options.frost.network.vpn.openvpn = {
    enable = lib.mkEnableOption "OpenVPN feature set";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];

    environment.systemPackages = with pkgs; [
      openvpn
    ];

    # Trust standard OpenVPN tunnels (tun0, tun1, etc.)
    networking.firewall.trustedInterfaces = [
      "tun+"
    ];
  };
}
