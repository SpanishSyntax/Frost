{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.media.audio.audiobookshelf;
in {
  options.frost.home.apps.media.audio.audiobookshelf.enable = lib.mkEnableOption "Audiobookshelft reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.audiobookshelf
    ];
  };
}
