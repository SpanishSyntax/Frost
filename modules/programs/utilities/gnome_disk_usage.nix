{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.programs.utilities.gnome_disk_usage;
in {
  options.frost.programs.utilities = {
    gnome_disk_usage.enable = lib.mkEnableOption "Gnome disk usage";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.baobab
    ];
  };
}
