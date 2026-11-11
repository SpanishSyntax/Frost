{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.snowpack;
in {
  imports = [inputs.snowpack.homeManagerModules.default];

  options.frost.home.apps.icebergs.snowpack = {
    enable = lib.mkEnableOption "Typst and Markdown document build tool";
  };

  config = lib.mkIf cfg.enable {
    programs.snowpack.enable = true;
  };
}
