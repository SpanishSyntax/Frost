{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.system.vulnix;
in {
  options.frost.home.apps.system.vulnix = {
    enable = lib.mkEnableOption "Vulnix vulnerability scanner";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vulnix
    ];
  };
}
