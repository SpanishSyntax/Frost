{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.programs.utilities.gnome_disks;
in {
  options.frost.programs.utilities.gnome_disks.enable = lib.mkEnableOption "Gnome disks";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gnome-disk-utility
    ];
  };
}
