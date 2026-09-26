{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.jq;
in {
  options.frost.home.apps.shell = {
    jq.enable = lib.mkEnableOption "Jq";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.jq
    ];
  };
}
