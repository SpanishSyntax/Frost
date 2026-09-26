{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.sioyek;
in {
  options.frost.home.apps.shell.sioyek.enable = lib.mkEnableOption "Sioyek";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sioyek
    ];
  };
}
