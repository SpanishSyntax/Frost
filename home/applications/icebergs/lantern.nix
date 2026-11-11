{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.lantern;
in {
  imports = [inputs.lantern.homeManagerModules.default];

  options.frost.home.apps.icebergs.lantern = {
    enable = lib.mkEnableOption "Frost's interactive explainer and simulation dashboard compiler";
  };

  config = lib.mkIf cfg.enable {
    programs.lantern.enable = true;
  };
}
