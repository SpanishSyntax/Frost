{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.services.bluetooth;
in {
  options.frost.home.services.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.frost.home.ui.wms.hyprland.enable;
      description = "Enable bluetooth CLI tools (defaults to true when Hyprland is enabled).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bluez
      bluez-tools
    ];
  };
}
