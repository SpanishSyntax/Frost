{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.nix;
in {
  options.frost.home.apps.langs.nix.enable = lib.mkEnableOption "Nix support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nix
      pkgs.nixd # LSP
      pkgs.alejandra # Formatter
      pkgs.statix # Linter
      pkgs.deadnix # Linter
    ];
  };
}
