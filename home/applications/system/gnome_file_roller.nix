{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.gnome_file_roller;
in {
  options.frost.home.apps.system.gnome_file_roller.enable = lib.mkEnableOption "Gnome file roller";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.file-roller
    ];
  };
}
