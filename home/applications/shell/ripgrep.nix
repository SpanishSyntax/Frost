{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.ripgrep;
in {
  options.frost.home.apps.shell.ripgrep = {
    enable = lib.mkEnableOption "Ripgrep search engine";
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };
  };
}
