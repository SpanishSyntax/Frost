{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.downloads.gnome_torrents;
in {
  options.frost.home.apps.downloads.gnome_torrents.enable = lib.mkEnableOption "Gnome torrents";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fragments
    ];
  };
}
