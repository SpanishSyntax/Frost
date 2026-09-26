{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.leisure.heroic;
in {
  options.frost.home.apps.leisure.heroic.enable = lib.mkEnableOption "Heroic";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  };
}
