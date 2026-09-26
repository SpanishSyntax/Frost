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
    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];
  };
}
