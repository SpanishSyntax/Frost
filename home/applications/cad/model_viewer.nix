{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.cad.model_viewer;
in {
  options.frost.home.apps.cad.model_viewer.enable = lib.mkEnableOption "3D model viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.exhibit
    ];
  };
}
