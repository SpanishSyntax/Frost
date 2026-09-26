{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.python;
in {
  options.frost.home.apps.langs.python.enable = lib.mkEnableOption "Python language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ruff # Janitor (ruff format) + Linter
      pkgs.ty # Brain (Static Type Analyzer)
    ];
    home.sessionVariables = {
      UV_PYTHON_DOWNLOADS = "false";
    };
  };
}
