{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.secret_tool;
in {
  options.frost.home.apps.system.shell.secret_tool.enable = lib.mkEnableOption "Secret-tool";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libsecret
    ];
  };
}
