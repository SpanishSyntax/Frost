{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.octave;
in {
  options.frost.home.apps.shell.octave.enable = lib.mkEnableOption "GNU Octave";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnuplot
      pkgs.octave
    ];
  };
}
