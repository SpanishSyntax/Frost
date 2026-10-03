{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.bentopdf;
in {
  options.frost.home.apps.office.bentopdf.enable = lib.mkEnableOption "Bentopdf";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bentopdf
    ];
  };
}
