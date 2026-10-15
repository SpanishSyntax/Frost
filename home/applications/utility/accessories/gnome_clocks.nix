{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.gnome_clocks;
in {
  options.frost.home.apps.utility.accessories.gnome_clocks.enable = lib.mkEnableOption "Gnome clocks";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-clocks
    ];
  };
}
