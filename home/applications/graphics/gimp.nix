{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.graphics.gimp;
in {
  options.frost.home.apps.graphics.gimp.enable = lib.mkEnableOption "Gimp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gimp
    ];
  };
}
