{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.fzf;
  zshCfg = config.frost.home.apps.system.shell.zsh;
in {
  options.frost.home.apps.system.shell.fzf = {
    enable = lib.mkEnableOption "FZF fuzzy finder with fd integration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fd
    ];

    programs.fzf = {
      enable = true;
      enableZshIntegration = zshCfg.enable;

      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";

      fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --exclude .git";

      fileWidgetOptions = [
        "--preview '${lib.getExe pkgs.bat} --color=always --line-range :500 {}'"
      ];
      historyWidgetOptions = ["--sort" "--exact"];
    };
  };
}
