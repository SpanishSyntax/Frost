{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.browsers.zen;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.frost.home.apps.browsers.zen.enable = lib.mkEnableOption "Zen browser.";

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
    };
  };
}
