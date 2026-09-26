{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.tree;
in {
  options.frost.home.apps.shell = {
    tree.enable = lib.mkEnableOption "Tree";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tree
    ];
  };
}
