{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.ai.opencode;
in {
  options.frost.home.apps.ai.opencode.enable = lib.mkEnableOption "Opencode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
    ];
  };
}
