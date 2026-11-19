{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.desktop.tools.borealis;
in {
  imports = [inputs.borealis.homeManagerModules.default];

  options.frost.home.desktop.tools.borealis = {
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
