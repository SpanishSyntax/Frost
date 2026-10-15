{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.chat.whatsapp;
in {
  options.frost.home.apps.network.chat.whatsapp.enable = lib.mkEnableOption "Whatsapp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zapzap
    ];
  };
}
