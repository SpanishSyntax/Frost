{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.personalization.fonts;
in {
  options.frost.personalization.fonts.enable =
    lib.mkEnableOption "Fonts";

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        inter

        libertinus
        source-serif
        source-sans
        source-code-pro
        eb-garamond
        merriweather
        recursive

        liberation_ttf

        corefonts
        vista-fonts

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        dejavu_fonts
        gyre-fonts
      ];

      fontDir.enable = true;

      fontconfig = {
        enable = true;

        defaultFonts = {
          sansSerif = [
            "Inter"
            "Arimo"
            "Noto Sans"
          ];

          serif = [
            "Libertinus Serif"
            "Tinos"
            "Noto Serif"
          ];

          monospace = [
            "Iosevka"
            "Noto Sans Mono"
          ];

          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}
