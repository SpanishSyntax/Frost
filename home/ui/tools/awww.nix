{
  config,
  lib,
  pkgs,
  linkConfig,
  ...
}: let
  cfg = config.frost.home.ui.tools.awww;
in {
  options.frost.home.ui.tools.awww = {
    enable = lib.mkEnableOption "awww";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awww" = {
      source = linkConfig "awww";
      recursive = true;
    };
    home.packages = with pkgs; [
      awww
    ];
  };
}
