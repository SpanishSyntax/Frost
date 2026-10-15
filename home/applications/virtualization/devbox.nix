{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.virtualization.devbox;
in {
  options.frost.home.apps.virtualization.devbox.enable = lib.mkEnableOption "Devbox development environment";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.devbox
    ];
  };
}
