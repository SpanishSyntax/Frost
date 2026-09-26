{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.creative.kdenlive;
in {
  options.frost.home.apps.creative.kdenlive.enable = lib.mkEnableOption "Kdenlive";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.kdenlive
    ];
  };
}
