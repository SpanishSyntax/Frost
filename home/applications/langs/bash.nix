{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.bash;
in {
  options.frost.home.apps.langs.bash.enable = lib.mkEnableOption "BASH support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bash-language-server
      pkgs.shfmt
      pkgs.shellcheck
    ];
  };
}
