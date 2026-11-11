{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.remote.dnsutils;
in {
  options.frost.home.apps.network.remote.dnsutils.enable = lib.mkEnableOption "Dnsutils";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.dnsutils
    ];
  };
}
