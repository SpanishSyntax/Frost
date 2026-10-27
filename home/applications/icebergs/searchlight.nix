{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.searchlight;
in {
  imports = [inputs.searchlight.homeManagerModules.default];

  options.frost.home.apps.icebergs.searchlight = {
    enable = lib.mkEnableOption "Interactive full-text PDF search, fuzzy discovery, and document preview engine";
  };

  config = lib.mkIf cfg.enable {
    programs.searchlight.enable = true;
  };
}

