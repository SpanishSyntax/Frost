{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.shell.glaze;
in {
  imports = [inputs.glaze.homeManagerModules.default];

  options.frost.home.apps.shell.glaze = {
    enable = lib.mkEnableOption "Universal space-to-underscore & capitalization utility";
  };

  config = lib.mkIf cfg.enable {
    programs.glaze.enable = true;
  };
}
