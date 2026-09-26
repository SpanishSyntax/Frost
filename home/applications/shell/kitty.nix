{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.kitty;
in {
  options.frost.home.apps.shell.kitty.enable = lib.mkEnableOption "Kitty terminal";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kitty
    ];
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      settings = {
        background_opacity = 0.75;
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
      };
      font = {
        package = pkgs.nerd-fonts._0xproto;
        name = "0xProto Nerd Font Mono";
        size = 12;
      };
    };
  };
}
