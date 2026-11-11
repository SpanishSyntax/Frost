{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.chat.discord;
in {
  options.frost.home.apps.network.chat.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.equibop
    ];
  };
}
