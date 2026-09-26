{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.zoxide;
in {
  options.frost.home.apps.shell = {
    zoxide.enable = lib.mkEnableOption "Zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
