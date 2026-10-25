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
    enable = lib.mkEnableOption "Universal space-to-underscore & capitalization utility";
  };

  config = lib.mkIf cfg.enable {
    programs.rime.enable = true;
  };
}
