{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.social.whatsapp;
in {
  options.frost.home.apps.social.whatsapp.enable = lib.mkEnableOption "Whatsapp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zapzap
    ];
  };
}
