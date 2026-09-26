{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.lua;
in {
  options.frost.home.apps.shell = {
    lua.enable = lib.mkEnableOption "Lua";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lua # lua
    ];
  };
}
