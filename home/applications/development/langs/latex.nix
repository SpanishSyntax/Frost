{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.langs.latex;
in {
  options.frost.home.apps.development.langs.latex.enable = lib.mkEnableOption "Latex support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.texlab # LSP
      pkgs.texlivePackages.latexindent # Formatter
      pkgs.proselint # Linter
    ];
  };
}
