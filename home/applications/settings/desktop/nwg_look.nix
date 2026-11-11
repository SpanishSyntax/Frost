{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.settings.desktop.nwg_look;
in {
  options.frost.home.apps.settings.desktop.nwg_look.enable = lib.mkEnableOption "nwg-look";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # nwg
      pkgs.nwg-look
    ];
  };
}
