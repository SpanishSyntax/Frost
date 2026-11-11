{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.eza;
  zshCfg = config.frost.home.apps.system.shell.zsh;
in {
  options.frost.home.apps.system.shell.eza = {
    enable = lib.mkEnableOption "Eza (modern, maintained ls replacement)";
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = zshCfg.enable;

      # Enable icons for directories and files (requires a Nerd Font)
      icons = "auto";

      # Show Git status indicators in long listings
      git = true;

      # Extra default flags: sort directories first
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
