{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.readers.foliate;
in {
  options.frost.home.apps.office.readers.foliate.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.foliate
    ];
  };
}
