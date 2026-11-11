{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.remote.iperf;
in {
  options.frost.home.apps.network.remote.iperf.enable = lib.mkEnableOption "Iperf";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.iperf
    ];
  };
}
