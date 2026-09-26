{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.file;
in {
  options.frost.home.apps.shell = {
    file.enable = lib.mkEnableOption "File";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.file
    ];
  };
}
