{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.readers.sioyek;
in {
  options.frost.home.apps.office.readers.sioyek.enable = lib.mkEnableOption "Sioyek";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sioyek
    ];
  };
}
