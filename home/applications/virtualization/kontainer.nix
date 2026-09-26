{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.virtualization.kontainer;
in {
  options.frost.home.apps.virtualization.kontainer.enable = lib.mkEnableOption "kontainer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kontainer
    ];
  };
}
