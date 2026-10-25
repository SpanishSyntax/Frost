{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.prism;
in {
  imports = [inputs.prism.homeManagerModules.default];

  options.frost.home.apps.icebergs.prism = {
    enable = lib.mkEnableOption "Crystalline zero-dependency terminal UI, ANSI styling, panels, and interactive menu engine";
  };

  config = lib.mkIf cfg.enable {
    programs.prism.enable = true;
  };
}
