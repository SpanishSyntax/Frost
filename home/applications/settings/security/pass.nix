{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.settings.security.pass;
in {
  options.frost.home.apps.settings.security.pass = {
    enable = lib.mkEnableOption "Pass (passage) password manager wrapper";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.passage
      (pkgs.writeShellScriptBin "pass" ''
        exec ${pkgs.passage}/bin/passage "$@"
      '')
    ];
  };
}
