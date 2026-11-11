{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.pandoc;
in {
  options.frost.home.apps.office.tools.pandoc.enable = lib.mkEnableOption "Pandoc";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pandoc
    ];
  };
}
