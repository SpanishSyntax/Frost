{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.ghostscript;
in {
  options.frost.home.apps.office.tools.ghostscript.enable = lib.mkEnableOption "Ghostscript";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ghostscript # ghostscript
    ];
  };
}
