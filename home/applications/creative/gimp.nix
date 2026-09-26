{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.creative.gimp;
in {
  options.frost.home.apps.creative.gimp.enable = lib.mkEnableOption "Gimp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gimp
    ];
  };
}
