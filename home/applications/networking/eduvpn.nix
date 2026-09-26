{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.eduvpn;
in {
  options.frost.home.apps.networking.eduvpn.enable = lib.mkEnableOption "EduVPN";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.eduvpn-client
    ];
  };
}
