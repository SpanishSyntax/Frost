{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.search;
in {
  options.frost.home.apps.shell = {
    search.enable = lib.mkEnableOption "Search";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fd
      pkgs.ripgrep
      pkgs.pdfgrep
    ];
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";

      # 1. Map your custom fd commands to the actual widget options
      fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --exclude .git";

      # 2. Add these to ensure the default keybinds trigger correctly
      fileWidgetOptions = ["--preview 'bat --color=always --line-range :500 {}'"]; # Optional but highly recommended!
      historyWidgetOptions = ["--sort" "--exact"]; # Optional tweaks for CTRL-R
    };
  };
}
