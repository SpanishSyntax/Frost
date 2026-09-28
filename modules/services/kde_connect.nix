{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.kde_connect;
in {
  options.frost.services.kde_connect.enable = lib.mkEnableOption "kde connect for phone pairing.";

  config = lib.mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}
