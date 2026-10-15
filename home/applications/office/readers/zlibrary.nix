{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.readers.readers.zlibrary;
in {
  options.frost.home.apps.office.readers.readers.zlibrary.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.z-library-desktop
    ];
  };
}
