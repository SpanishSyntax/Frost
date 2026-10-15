{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.video.kdenlive;
in {
  options.frost.home.apps.video.kdenlive.enable = lib.mkEnableOption "Kdenlive";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.kdenlive
    ];
  };
}
