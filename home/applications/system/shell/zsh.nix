{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.zsh;
in {
  options.frost.home.apps.system.shell.zsh = {
    enable = lib.mkEnableOption "Zsh config";

    autostartFastfetch = lib.mkEnableOption "autostart fastfetch on interactive shell start";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."zsh.d" = {
      source = config.frost.home.environment.mkSource "zsh.d";
      recursive = true;
    };

    programs.zsh = {
      enable = true;

      initContent = ''
        ${lib.optionalString cfg.autostartFastfetch ''
          [[ -o interactive ]] && ${pkgs.fastfetch}/bin/fastfetch
        ''}

        [[ -f "${config.xdg.configHome}/zsh.d/custom.zsh" ]] && source "${config.xdg.configHome}/zsh.d/custom.zsh"

        for file in "${config.xdg.configHome}/zsh.d/conf.d"/*.zsh(N); do
          source "$file"
        done
      '';

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
      };

      plugins = [
        {
          name = "you-should-use";
          src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
        }
        {
          name = "zsh-z";
          src = "${pkgs.zsh-z}/share/zsh/plugins/zsh-z";
        }
      ];
    };
  };
}
