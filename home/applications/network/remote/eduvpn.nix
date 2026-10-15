{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.remote.eduvpn;
in {
  options.frost.home.apps.network.remote.eduvpn.enable = lib.mkEnableOption "EduVPN";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.eduvpn-client
    ];
  };
}
