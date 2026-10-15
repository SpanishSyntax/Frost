{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.readers.readers.calibre;
in {
  options.frost.home.apps.office.readers.readers.calibre.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.calibre
    ];
  };
}
