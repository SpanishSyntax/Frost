{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.desktop.tools.awww;
in {
  options.frost.home.desktop.tools.awww = {
    enable = lib.mkEnableOption "awww";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awww" = {
      source = config.frost.home.environment.mkSource "awww";
      recursive = true;
    };
    home.packages = with pkgs; [
      awww
    ];
  };
}
