{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.pandoc;
in {
  options.frost.home.apps.shell.pandoc.enable = lib.mkEnableOption "Pandoc";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pandoc
    ];
  };
}
