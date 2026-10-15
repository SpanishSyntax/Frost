{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.langs.cpp;
in {
  options.frost.home.apps.development.langs.cpp.enable =
    lib.mkEnableOption "C/C++ development support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.clang-tools # Brain (clangd) + Janitor (clang-format)
    ];
  };
}
