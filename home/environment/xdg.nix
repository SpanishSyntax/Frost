{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.environment.xdg;
in {
  options.frost.home.environment.xdg.enable = lib.mkEnableOption "XDG";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      xdg-user-dirs
      xdg-user-dirs-gtk
      xdg-utils
    ];

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };

      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "zen-twilight.desktop";
          "x-scheme-handler/http" = "zen-twilight.desktop";
          "x-scheme-handler/https" = "zen-twilight.desktop";
          "x-scheme-handler/about" = "zen-twilight.desktop";
          "x-scheme-handler/unknown" = "zen-twilight.desktop";
          "x-scheme-handler/terminal" = "kitty.desktop";

          # Set Sioyek as the primary PDF / document reader
          "application/pdf" = "sioyek.desktop";
          "application/oxps" = "sioyek.desktop";
          "application/epub+zip" = "sioyek.desktop";
          "application/x-fictionbook+xml" = "sioyek.desktop";

          "inode/directory" = "org.gnome.Nautilus.desktop";
          "image/png" = "org.gnome.Loupe.desktop";
          "image/jpeg" = "org.gnome.Loupe.desktop";
          "image/jpg" = "org.gnome.Loupe.desktop";

          # Plain text and code configurations
          "text/plain" = "nvim.desktop";
          "application/x-zerosize" = "nvim.desktop"; # Empty files

          # Language-specific source code files
          "text/x-chdr" = "nvim.desktop"; # C/C++ Headers
          "text/x-csrc" = "nvim.desktop"; # C source
          "text/x-c++hdr" = "nvim.desktop";
          "text/x-c++src" = "nvim.desktop"; # C++ source
          "text/x-go" = "nvim.desktop";
          "text/x-java" = "nvim.desktop";
          "text/x-javascript" = "nvim.desktop";
          "text/x-julia" = "nvim.desktop";
          "text/x-lua" = "nvim.desktop";
          "text/x-nix" = "nvim.desktop";
          "text/x-python" = "nvim.desktop";
          "text/rustsrc" = "nvim.desktop";
          "text/x-sh" = "nvim.desktop"; # Bash

          # Data, markup, and config formats
          "text/markdown" = "nvim.desktop";
          "text/x-tex" = "nvim.desktop"; # LaTeX
          "text/x-typst" = "nvim.desktop"; # Typst
          "application/toml" = "nvim.desktop";
          "application/yaml" = "nvim.desktop";
          "text/x-nginx-conf" = "nvim.desktop";
        };
      };
    };
  };
}
