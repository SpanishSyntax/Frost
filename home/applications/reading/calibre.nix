{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.reading.calibre;
in {
  options.frost.home.apps.reading.calibre.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.calibre
    ];
  };
}
