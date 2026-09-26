{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.system.zip;
in {
  options.frost.home.apps.system.zip = {
    enable = lib.mkEnableOption "Archive compression utilities (zip, p7zip, ouch)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zip
      pkgs.p7zip
      pkgs.ouch
    ];
  };
}
