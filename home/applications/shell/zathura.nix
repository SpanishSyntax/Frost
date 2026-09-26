{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.zathura;
in {
  options.frost.home.apps.shell.zathura.enable = lib.mkEnableOption "Zathura document viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zathura
    ];
  };
}
