{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.gnome_network_displays;
in {
  options.frost.home.apps.networking.gnome_network_displays.enable = lib.mkEnableOption "Gnome network displays";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-network-displays
    ];
  };
}
