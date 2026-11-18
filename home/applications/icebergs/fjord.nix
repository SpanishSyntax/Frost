{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.fjord;
  pkg =
    if inputs ? fjord
    then inputs.fjord.packages.${pkgs.stdenv.hostPlatform.system}.default
    else pkgs.writeShellScriptBin "wormhole" "echo 'fjord input missing'; exit 1";
in {
  options.frost.home.apps.icebergs.fjord = {
    enable = lib.mkEnableOption "Fjord (Wormhole) Material 3 XDG Desktop Portal daemon & dialogs";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      description = "The Wormhole package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.symlinkJoin {
        name = "fjord-wrapped";
        paths = [
          (pkgs.writeShellScriptBin "fjord" ''
            exec ${cfg.package}/bin/wormhole "$@"
          '')
          cfg.package
        ];
      })
    ];
  };
}
