{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.borealis;
in {
  imports = [inputs.borealis.homeManagerModules.default];

  options.frost.home.apps.icebergs.borealis = {
    enable = lib.mkEnableOption "Borealis wallpaper engine.";
  };

  config = lib.mkIf cfg.enable {
    services.borealis = {
      enable = true;
      backend = "awww";
      interval = 20;
    };
  };
}
