{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.pdfgrep;
in {
  options.frost.home.apps.shell = {
    pdfgrep.enable = lib.mkEnableOption "PDFgrep utility for searching text in PDF files";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pdfgrep
    ];
  };
}
