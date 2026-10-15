{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.utility.accessories.memorado;
in {
  options.frost.home.apps.utility.accessories.memorado.enable = lib.mkEnableOption "Memorado";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.memorado
    ];
  };
}
