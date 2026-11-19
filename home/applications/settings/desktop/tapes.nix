{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.settings.desktop.tapes;
  system = pkgs.stdenv.hostPlatform.system;

  defaultPkg =
    if inputs ? tapes
    then inputs.tapes.packages.${system}.default
    else pkgs.writeShellScriptBin "tapes" "echo 'tapes input missing'; exit 1";

  defaultGuiPkg =
    if inputs ? tapes-deck
    then inputs.tapes-deck.packages.${system}.default
    else pkgs.writeShellScriptBin "tapes-deck" "echo 'tapes-deck input missing'; exit 1";
in {
  options.frost.home.apps.settings.desktop.tapes = {
    enable = lib.mkEnableOption "Tapes v2 atomic per-target dotfile switcher";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Tapes CLI package to use.";
    };

    gui = {
      enable = lib.mkEnableOption "Tapes-Deck official GUI for Tapes";

      package = lib.mkOption {
        type = lib.types.package;
        default = defaultGuiPkg;
        description = "The Tapes-Deck GUI package to use.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [cfg.package]
      ++ lib.optional cfg.gui.enable cfg.gui.package;
  };
}
