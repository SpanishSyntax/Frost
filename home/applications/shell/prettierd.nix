{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.prettierd;
in {
  options.frost.home.apps.shell = {
    prettierd.enable = lib.mkEnableOption "Prettierd";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.prettierd # prettyfier
    ];
  };
}
