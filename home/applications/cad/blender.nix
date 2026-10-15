{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.cad.blender;
in {
  options.frost.home.apps.cad.blender.enable = lib.mkEnableOption "Blender";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.blender
    ];
  };
}
