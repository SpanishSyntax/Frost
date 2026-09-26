{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.devbox;
in {
  options.frost.home.apps.development.devbox.enable = lib.mkEnableOption "Devbox development environment";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.devbox
    ];
  };
}
