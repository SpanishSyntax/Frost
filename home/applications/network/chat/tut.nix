{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.chat.tut;
in {
  options.frost.home.apps.network.chat.tut = {
    enable = lib.mkEnableOption "tut";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tut
    ];
  };
}
