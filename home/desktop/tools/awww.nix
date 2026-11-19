{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.desktop.tools.awww;
in {
  options.frost.home.desktop.tools.awww = {
    enable = lib.mkEnableOption "awww";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.awww
    ];
  };
}
