{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.dnsutils;
in {
  options.frost.home.apps.networking.dnsutils.enable = lib.mkEnableOption "Dnsutils";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.dnsutils
    ];
  };
}
