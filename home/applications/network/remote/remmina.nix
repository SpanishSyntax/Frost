{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.remote.remmina;
in {
  options.frost.home.apps.network.remote.remmina.enable = lib.mkEnableOption "Remmina VNC";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.remmina
    ];
  };
}
