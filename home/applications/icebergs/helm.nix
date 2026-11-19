{
  config,
  lib,
  pkgs,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.helm;
  pkg =
    if inputs ? helm
    then inputs.helm.packages.${pkgs.stdenv.hostPlatform.system}.default
    else pkgs.writeShellScriptBin "flightdeck" "echo 'helm input missing'; exit 1";
in {
  options.frost.home.apps.icebergs.helm = {
    enable = lib.mkEnableOption "Helm Hyprland configuration manager";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      description = "The Helm package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (wrapBin pkgs {
        pkg = cfg.package;
        name = "helm";
        target = "flightdeck";
        displayName = "Helm";
      })
    ];
  };
}
