{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.folio;
in {
  imports = [inputs.folio.homeManagerModules.default];

  options.frost.home.apps.icebergs.folio = {
    enable = lib.mkEnableOption "Typst and Markdown document build tool";
  };

  config = lib.mkIf cfg.enable {
    programs.folio.enable = true;
  };
}
