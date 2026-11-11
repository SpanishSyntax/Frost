{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.zoxide;
  zshCfg = config.frost.home.apps.system.shell.zsh;
in {
  options.frost.home.apps.system.shell.zoxide = {
    enable = lib.mkEnableOption "Zoxide smarter cd command";

    replaceCd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Replace builtin `cd` with `z` across interactive shells.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = zshCfg.enable;
      options = lib.optional cfg.replaceCd "--cmd cd";
    };

    home.sessionVariables = {
      _ZO_FZF_OPTS = "--exact --no-sort";
    };
  };
}
