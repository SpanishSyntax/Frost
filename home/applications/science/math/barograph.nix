{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.science.math.barograph;
in {
  imports = [inputs.barograph.homeManagerModules.default];

  options.frost.home.apps.science.math.barograph = {
    enable = lib.mkEnableOption "Batch runner, multi-backend export engine & live-reloading preview server for Python plotting scripts";
  };

  config = lib.mkIf cfg.enable {
    programs.barograph.enable = true;
  };
}
