{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.bento_pdf;
in {
  options.frost.home.apps.office.bento_pdf.enable = lib.mkEnableOption "Bentopdf";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bento_pdf
    ];
  };
}
