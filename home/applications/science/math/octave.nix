{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.science.math.octave;
in {
  options.frost.home.apps.science.math.octave.enable = lib.mkEnableOption "GNU Octave";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnuplot
      pkgs.octave
    ];
  };
}
