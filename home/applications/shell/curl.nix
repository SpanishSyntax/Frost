{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.curl;
in {
  options.frost.home.apps.shell = {
    curl.enable = lib.mkEnableOption "Curl";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.curl
    ];
  };
}
