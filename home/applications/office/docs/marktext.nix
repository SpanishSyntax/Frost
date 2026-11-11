{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.docs.marktext;
in {
  options.frost.home.apps.office.docs.marktext.enable = lib.mkEnableOption "Marktext";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.marktext
    ];
  };
}
