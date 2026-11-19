{
  config,
  pkgs,
  lib,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.desktop.tools.igloo_cli;
  system = pkgs.stdenv.hostPlatform.system;
  defaultPkg =
    if inputs ? igloo-cli
    then inputs.igloo-cli.packages.${system}.default
    else if inputs ? igloo && (inputs.igloo.inputs or {}) ? caelestia-cli
    then inputs.igloo.inputs.caelestia-cli.packages.${system}.default
    else pkgs.writeShellScriptBin "caelestia" "echo 'igloo-cli input missing'; exit 1";
in {
  options.frost.home.desktop.tools.igloo_cli = {
    enable = lib.mkEnableOption "Igloo (Caelestia) CLI and companion Wayland utilities";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Igloo CLI package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.frost.home.desktop.shells.igloo.enable;
        message = "frost.home.desktop.tools.igloo_cli requires frost.home.desktop.shells.igloo.enable = true.";
      }
    ];

    home.packages = [
      (wrapBin pkgs {
        pkg = cfg.package;
        name = "igloo";
        target = "caelestia";
        hideTarget = false;
      })
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.fuzzel
      pkgs.ydotool
      pkgs.hyprpicker
      pkgs.hyprcursor
    ];
  };
}
