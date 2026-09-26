{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.calculator;
in {
  options.frost.home.apps.utils.calculator.enable = lib.mkEnableOption "Gnome calculator";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bc # some calculator
      pkgs.libqalculate
    ];
  };
}
