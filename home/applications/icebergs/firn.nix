{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.firn;
in {
  imports = [inputs.firn.homeManagerModules.default];

  options.frost.home.apps.icebergs.firn = {
    enable = lib.mkEnableOption "Github markdown renderer";
  };

  config = lib.mkIf cfg.enable {
    programs.firn.enable = true;
  };
}
