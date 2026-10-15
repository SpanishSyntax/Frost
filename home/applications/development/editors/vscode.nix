{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.editors.vscode;
in {
  options.frost.home.apps.development.editors.vscode.enable = lib.mkEnableOption "Vscode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vscode
    ];
  };
}
