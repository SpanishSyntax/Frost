{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.virtualization.kontainer;
in {
  options.frost.home.apps.system.virtualization.kontainer.enable = lib.mkEnableOption "kontainer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kontainer
    ];
  };
}
