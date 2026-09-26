{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.remmina;
in {
  options.frost.home.apps.networking.remmina.enable = lib.mkEnableOption "Remmina VNC";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.remmina
    ];
  };
}
