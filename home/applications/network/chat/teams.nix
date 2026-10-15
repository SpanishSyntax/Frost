{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.chat.teams;
in {
  options.frost.home.apps.network.chat.teams.enable = lib.mkEnableOption "Microsoft Teams";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.teams-for-linux
    ];
  };
}
