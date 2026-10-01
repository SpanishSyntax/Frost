{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.social.tut;
  dotfiles = "${config.home.homeDirectory}/Frost/home/configs";
in {
  options.frost.home.apps.social.tut = {
    enable = lib.mkEnableOption "tut";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tut
    ];

    xdg.configFile."tut" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tut";
      recursive = true;
    };
  };
}
