{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.desktop.tools.caelestia_cli;
  system = pkgs.stdenv.hostPlatform.system;
  defaultPkg =
    if inputs ? caelestia-cli
    then inputs.caelestia-cli.packages.${system}.default
    else if inputs ? caelestia-shell && (inputs.caelestia-shell.inputs or {}) ? caelestia-cli
    then inputs.caelestia-shell.inputs.caelestia-cli.packages.${system}.default
    else pkgs.writeShellScriptBin "caelestia" "echo 'caelestia-cli input missing'; exit 1";
  featuredTapes = config.frost.home.apps.settings.desktop.tapes.featured or [];
  caelestiaTapeEnabled =
    (config.frost.home.apps.settings.desktop.tapes.enable or false)
    && builtins.elem "caelestia" featuredTapes;
in {
  options.frost.home.desktop.tools.caelestia_cli = {
    enable = lib.mkEnableOption "Caelestia CLI and companion Wayland utilities";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Caelestia CLI package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.frost.home.desktop.shells.caelestia.enable;
        message = "frost.home.desktop.tools.caelestia_cli requires frost.home.desktop.shells.caelestia.enable = true.";
      }
    ];

    home.packages =
      [cfg.package]
      ++ lib.optionals (!caelestiaTapeEnabled) [
        pkgs.cliphist
        pkgs.wl-clipboard
        pkgs.fuzzel
        pkgs.ydotool
        pkgs.hyprpicker
        pkgs.hyprcursor
      ];
  };
}
