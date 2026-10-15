{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.docs.rnote;
in {
  options.frost.home.apps.office.docs.rnote.enable = lib.mkEnableOption "Rnote";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rnote
    ];
  };
}
