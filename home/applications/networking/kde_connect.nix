{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.networking.kde_connect;
in {
  options.frost.home.apps.networking.kde_connect.enable = lib.mkEnableOption "kde connect for phone pairing.";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.scrcpy
    ];
    services.kdeconnect.enable = true;
  };
}
