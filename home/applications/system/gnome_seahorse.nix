{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.gnome_seahorse;
in {
  options.frost.home.apps.system.gnome_seahorse.enable = lib.mkEnableOption "Gnome seahorse";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.seahorse
    ];
  };
}
