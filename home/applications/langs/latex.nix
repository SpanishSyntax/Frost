{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.latex;
in {
  options.frost.home.apps.langs.latex.enable = lib.mkEnableOption "Latex support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.texlab # LSP
      pkgs.texlivePackages.latexindent # Formatter
      pkgs.proselint # Linter
    ];
  };
}
