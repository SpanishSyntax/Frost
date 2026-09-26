{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.nwg;
in {
  options.frost.home.apps.system.nwg.enable = lib.mkEnableOption "nwg-look";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # nwg
      pkgs.nwg-look
    ];
  };
}
