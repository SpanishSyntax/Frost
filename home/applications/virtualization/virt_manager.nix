{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.virtualization.virt_manager;
in {
  options.frost.home.apps.virtualization.virt_manager.enable = lib.mkEnableOption "Virt-manager";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.virt-manager
    ];
  };
}
