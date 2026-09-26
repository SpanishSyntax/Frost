{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.openvpn;
in {
  options.frost.services.openvpn = {
    enable = lib.mkEnableOption "OpenVPN feature set";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];
    environment.systemPackages = with pkgs; [
      openvpn
    ];
  };
}
