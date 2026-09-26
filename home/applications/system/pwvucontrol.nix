{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.pwvucontrol;
in {
  options.frost.home.apps.system.pwvucontrol.enable = lib.mkEnableOption "Pwvucontrol";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pwvucontrol
    ];
  };
}
