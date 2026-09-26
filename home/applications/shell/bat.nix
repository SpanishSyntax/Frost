{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.bat;
in {
  options.frost.home.apps.shell = {
    bat.enable = lib.mkEnableOption "Bat";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bat # cat but better
    ];
  };
}
