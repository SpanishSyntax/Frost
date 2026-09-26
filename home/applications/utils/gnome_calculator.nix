{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.gnome_calculator;
in {
  options.frost.home.apps.utils.gnome_calculator.enable = lib.mkEnableOption "Gnome calculator";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-calculator
    ];
  };
}
