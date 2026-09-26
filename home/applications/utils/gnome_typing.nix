{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_typing;
in {
  options.frost.home.apps.utils.gnome_typing.enable = lib.mkEnableOption "Gnome typing";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.keypunch
    ];
  };
}
