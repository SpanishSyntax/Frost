{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.vscode;
in {
  options.frost.home.apps.development.vscode.enable = lib.mkEnableOption "Vscode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vscode
    ];
  };
}
