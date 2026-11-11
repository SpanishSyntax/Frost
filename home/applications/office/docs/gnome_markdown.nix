{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.docs.gnome_markdown;
in {
  options.frost.home.apps.office.docs.gnome_markdown.enable = lib.mkEnableOption "Gnome markdown";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.apostrophe
    ];
  };
}
