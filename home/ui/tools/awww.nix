{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.ui.tools.awww;
  dotfiles = "${config.home.homeDirectory}/Frost/home/configs";
in {
  options.frost.home.ui.tools.awww = {
    enable = lib.mkEnableOption "awww";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."awww" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/awww";
      recursive = true;
    };
    home.packages = with pkgs; [
      awww
    ];
  };
}
