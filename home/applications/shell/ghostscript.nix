{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.ghostscript;
in {
  options.frost.home.apps.shell = {
    ghostscript.enable = lib.mkEnableOption "Ghostscript";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ghostscript # ghostscript
    ];
  };
}
