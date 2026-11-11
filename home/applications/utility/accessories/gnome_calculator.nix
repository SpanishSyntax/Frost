{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.gnome_calculator;
in {
  options.frost.home.apps.utility.accessories.gnome_calculator.enable = lib.mkEnableOption "Gnome calculator";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-calculator
    ];
  };
}
