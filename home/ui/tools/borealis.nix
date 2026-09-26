{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.ui.tools.borealis;
in {
  imports = [inputs.borealis.homeManagerModules.default];
  options.frost.home.ui.tools.borealis = {
    enable = lib.mkEnableOption "borealis";
  };

  config = lib.mkIf cfg.enable {
    services.borealis = {
      enable = true;
      backend = "awww";
      interval = 20;
    };
  };
}
