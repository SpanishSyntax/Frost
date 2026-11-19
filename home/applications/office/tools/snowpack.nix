{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.snowpack;
in {
  imports = [inputs.snowpack.homeManagerModules.default];

  options.frost.home.apps.office.tools.snowpack = {
    enable = lib.mkEnableOption "Typst and Markdown document build tool";
  };

  config = lib.mkIf cfg.enable {
    programs.snowpack.enable = true;
  };
}
