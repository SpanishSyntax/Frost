{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.calculator;
in {
  options.frost.home.apps.utility.accessories.calculator.enable = lib.mkEnableOption "Gnome calculator";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bc # some calculator
      pkgs.libqalculate
    ];
  };
}
