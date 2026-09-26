{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_clocks;
in {
  options.frost.home.apps.utils.gnome_clocks.enable = lib.mkEnableOption "Gnome clocks";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-clocks
    ];
  };
}
