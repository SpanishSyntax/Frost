{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.virtualization.distrobox;
in {
  options.frost.home.apps.virtualization.distrobox.enable = lib.mkEnableOption "Distrobox";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.distrobox
      pkgs.distrobox-tui
    ];
  };
}
