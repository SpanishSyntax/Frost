{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.creative.blender;
in {
  options.frost.home.apps.creative.blender.enable = lib.mkEnableOption "Blender";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.blender
    ];
  };
}
