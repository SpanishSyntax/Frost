{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.social.teams;
in {
  options.frost.home.apps.social.teams.enable = lib.mkEnableOption "Microsoft Teams";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.teams-for-linux
    ];
  };
}
