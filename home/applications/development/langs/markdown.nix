{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.langs.markdown;
in {
  options.frost.home.apps.development.langs.markdown.enable = lib.mkEnableOption "Markdown support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.marksman # LSP
      pkgs.mdx-language-server # MDX LSP
      pkgs.markdownlint-cli2 # Linter
      pkgs.prettierd # Formatter
    ];
  };
}
