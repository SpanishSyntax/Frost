{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.lua;
in {
  options.frost.home.apps.langs.lua = {
    enable = lib.mkEnableOption "Lua language tooling and runtime";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lua # Interpreter/runtime
      pkgs.lua-language-server # LSP
      pkgs.stylua # Formatter
      pkgs.selene # Linter
    ];
  };
}
