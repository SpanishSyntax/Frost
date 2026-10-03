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
    ];
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
      fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --exclude .git";
    };
  };
}
