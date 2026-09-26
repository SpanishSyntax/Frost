{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utils.memorado;
in {
  options.frost.home.apps.utils.memorado.enable = lib.mkEnableOption "Memorado";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.memorado
    ];
  };
}
