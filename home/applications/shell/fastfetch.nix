{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.fastfetch;
in {
  options.frost.home.apps.shell = {
    fastfetch.enable = lib.mkEnableOption "Fastfetch";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fastfetch # fastfetch LOL
    ];
  };
}
