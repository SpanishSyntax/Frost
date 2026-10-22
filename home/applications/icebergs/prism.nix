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
    enable = lib.mkEnableOption "Batch runner, multi-backend export engine & live-reloading preview server for Python plotting scripts";
  };

  config = lib.mkIf cfg.enable {
    programs.prism.enable = true;
  };
}
