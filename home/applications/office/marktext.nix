{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.marktext;
in {
  options.frost.home.apps.office.marktext.enable = lib.mkEnableOption "Marktext";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.marktext
    ];
  };
}
