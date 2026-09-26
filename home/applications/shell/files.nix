{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.files;
in {
  options.frost.home.apps.shell = {
    files.enable = lib.mkEnableOption "Files";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fd
      pkgs.fzf
      pkgs.ripgrep
    ];
  };
}
