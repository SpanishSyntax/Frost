{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.starship;
in {
  options.frost.home.apps.shell.starship.enable = lib.mkEnableOption "Starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      presets = ["gruvbox-rainbow"];
      settings = {
        hostname.ssh_only = false;
      };
    };
  };
}
