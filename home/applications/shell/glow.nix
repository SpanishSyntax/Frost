{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.glow;
in {
  options.frost.home.apps.shell = {
    glow.enable = lib.mkEnableOption "Glow";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.glow
    ];
  };
}
