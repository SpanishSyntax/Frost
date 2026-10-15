{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.gnome_typing;
in {
  options.frost.home.apps.utility.accessories.gnome_typing.enable = lib.mkEnableOption "Gnome typing";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.keypunch
    ];
  };
}
