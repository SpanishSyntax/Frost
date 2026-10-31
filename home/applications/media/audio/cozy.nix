{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.media.audio.cozy;
in {
  options.frost.home.apps.media.audio.cozy.enable = lib.mkEnableOption "Cozy Audiobook reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.cozy
    ];
  };
}
