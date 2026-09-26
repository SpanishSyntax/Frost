{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.environment.fonts;
in {
  options.frost.home.environment.fonts.enable =
    lib.mkEnableOption "Fonts";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.victor-mono

      font-awesome
      material-design-icons
    ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Iosevka Nerd Font"
          "Iosevka"
          "Noto Sans Mono"
        ];
      };
    };
  };
}
