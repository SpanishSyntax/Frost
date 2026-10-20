{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.rime;
in {
  imports = [inputs.rime.homeManagerModules.default];

  options.frost.home.apps.icebergs.rime = {
    enable = lib.mkEnableOption "Crystalline zero-dependency terminal UI, ANSI styling, panels, and interactive menu engine";
  };

  config = lib.mkIf cfg.enable {
    programs.rime.enable = true;
  };
}
