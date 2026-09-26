{
  pkgs,
  config,
  lib,
  
  ...
}: let
  cfg = config.frost.home.ui.des.gnome;
in {
  options.frost.home.ui.des = {
    gnome.enable = lib.mkEnableOption "Gnome feature set";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
    ];
  };
}
