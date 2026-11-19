{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.settings.desktop.tapes;
  pkg =
    if inputs ? tapes
    then inputs.tapes.packages.${pkgs.stdenv.hostPlatform.system}.default
    else pkgs.writeShellScriptBin "tapes" "echo 'tapes input missing'; exit 1";
in {
  options.frost.home.apps.settings.desktop.tapes = {
    enable = lib.mkEnableOption "Tapes v2 atomic per-target dotfile switcher";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      description = "The Tapes CLI package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
