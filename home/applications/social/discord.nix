{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.social.discord;
in {
  options.frost.home.apps.social.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.equibop
    ];
  };
}
