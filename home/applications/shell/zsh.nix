{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.shell.zsh;
in {
  options.frost.home.apps.shell.zsh = {
    enable = lib.mkEnableOption "Zsh config";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to flox configs for out-of-store symlinking.
        Defaults to global `frost.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."zsh.d" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/zsh.d"
        else "${inputs.self}/home/configs/zsh.d";
      recursive = true;
    };

    programs.zsh = {
      enable = true;

      initContent = ''
        # Source custom file if present
        [[ -f "${config.xdg.configHome}/zsh.d/custom.zsh" ]] && source "${config.xdg.configHome}/zsh.d/custom.zsh"

        # (N) nullglob qualifier prevents 'no matches found' errors if folder is empty
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
