{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.wget;
in {
  options.frost.home.apps.shell = {
    wget.enable = lib.mkEnableOption "Wget";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wget
    ];
  };
}
