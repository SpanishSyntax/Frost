{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.environment.gtk;
in {
  options.frost.home.environment.gtk.enable = lib.mkEnableOption "GTK config";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      gtk3.colorScheme = "dark";
      gtk4.colorScheme = "dark";

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
      #   font = {
      #     name = "Sans";
      #     size = 11;
      #   };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "Adwaita-dark";
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };
}
