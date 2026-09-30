{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.gaming.heroic;
in {
  options.frost.home.apps.gaming.heroic.enable = lib.mkEnableOption "Heroic";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  };
}
