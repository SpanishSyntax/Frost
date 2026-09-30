{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.reading.zlibrary;
in {
  options.frost.home.apps.reading.zlibrary.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.z-library-desktop
    ];
  };
}
