{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.magika;
in {
  options.frost.home.apps.system.shell.magika = {
    enable = lib.mkEnableOption "Modern file type inspection utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      magika-cli
    ];
  };
}
