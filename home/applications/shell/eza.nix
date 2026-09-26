{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.eza;
in {
  options.frost.home.apps.shell = {
    eza.enable = lib.mkEnableOption "Eza";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.eza # ls replacement
    ];
  };
}
