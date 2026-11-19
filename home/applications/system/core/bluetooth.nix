{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.core.bluetooth;
in {
  options.frost.home.apps.system.core.bluetooth = {
    enable = lib.mkEnableOption "bluetooth CLI tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bluez
      bluez-tools
    ];
  };
}
