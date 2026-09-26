{
  config,
  pkgs,
  lib,
  linkConfig,
  ...
}: let
  cfg = config.frost.home.apps.social.tut;
in {
  options.frost.home.apps.social.tut = {
    enable = lib.mkEnableOption "tut";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tut
    ];

    xdg.configFile."tut" = {
      source = linkConfig "tut";
      recursive = true;
    };
  };
}
