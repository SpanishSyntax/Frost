{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.transfer.gnome_torrents;
in {
  options.frost.home.apps.network.transfer.gnome_torrents.enable = lib.mkEnableOption "Gnome torrents";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fragments
    ];
  };
}
