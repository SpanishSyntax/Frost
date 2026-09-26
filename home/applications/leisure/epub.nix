{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.leisure.epub;
in {
  options.frost.home.apps.leisure.epub.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.foliate
      pkgs.calibre
      pkgs.z-library-desktop
    ];
  };
}
