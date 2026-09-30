{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.reading.foliate;
in {
  options.frost.home.apps.reading.foliate.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.foliate
    ];
  };
}
