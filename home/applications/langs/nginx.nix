{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.nginx;
in {
  options.frost.home.apps.langs.nginx.enable = lib.mkEnableOption "Nginx support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nginx-language-server # LSP
    ];
  };
}
