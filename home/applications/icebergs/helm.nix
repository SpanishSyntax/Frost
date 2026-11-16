{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.helm;
in {
  imports = [inputs.helm.homeManagerModules.default];

  options.frost.home.apps.icebergs.helm = {
    enable = lib.mkEnableOption "Helm (FlightDeck) Hyprland configuration manager";
  };

  config = lib.mkIf cfg.enable {
    programs.helm.enable = true;
  };
}
