{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.sqlite;
in {
  options.frost.home.apps.system.sqlite.enable = lib.mkEnableOption "SQLite support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # SQLite
      pkgs.sqlite

      # LSP
      pkgs.sqls
    ];
  };
}
