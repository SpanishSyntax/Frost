{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.iperf;
in {
  options.frost.home.apps.networking.iperf.enable = lib.mkEnableOption "Iperf";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.iperf
    ];
  };
}
