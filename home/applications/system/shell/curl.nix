{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.curl;
in {
  options.frost.home.apps.system.shell.curl.enable = lib.mkEnableOption "Curl";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.curl
    ];
  };
}
