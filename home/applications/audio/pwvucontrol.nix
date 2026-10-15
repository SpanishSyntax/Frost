{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.audio.pwvucontrol;
in {
  options.frost.home.apps.audio.pwvucontrol.enable = lib.mkEnableOption "Pwvucontrol";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pwvucontrol
    ];
  };
}
