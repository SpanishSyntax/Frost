{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.chat.telegram;
in {
  options.frost.home.apps.network.chat.telegram.enable = lib.mkEnableOption "Telegram";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.telegram-desktop
    ];
  };
}
