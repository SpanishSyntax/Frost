{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.tor;
in {
  options.frost.home.apps.networking.tor.enable = lib.mkEnableOption "Tor Browser";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.tor-browser
    ];
  };
}
