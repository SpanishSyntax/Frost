{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.rnote;
in {
  options.frost.home.apps.office.rnote.enable = lib.mkEnableOption "Rnote";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rnote
    ];
  };
}
