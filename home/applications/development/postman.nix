{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.postman;
in {
  options.frost.home.apps.development.postman.enable = lib.mkEnableOption "Postman";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.postman
    ];
  };
}
