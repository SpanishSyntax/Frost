{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.glow;
in {
  options.frost.home.apps.system.shell.glow.enable = lib.mkEnableOption "Glow";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.glow
    ];
  };
}
