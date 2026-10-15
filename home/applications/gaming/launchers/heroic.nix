{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.gaming.launchers.heroic;
in {
  options.frost.home.apps.gaming.launchers.heroic.enable = lib.mkEnableOption "Heroic";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  };
}
