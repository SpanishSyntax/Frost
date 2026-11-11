{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.wireguard;
in {
  options.frost.services.wireguard = {
    enable = lib.mkEnableOption "WireGuard feature set";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["wireguard"];

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];

    # Trust standard WireGuard tunnels (wg0, wg1, etc.)
    networking.firewall.trustedInterfaces = [
      "wg+"
    ];
  };
}
