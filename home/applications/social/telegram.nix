{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.social.telegram;
in {
  options.frost.home.apps.social.telegram.enable = lib.mkEnableOption "Telegram";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.telegram-desktop
    ];
  };
}
