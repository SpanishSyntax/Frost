{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.office.readers.goggles;
in {
  imports = [inputs.goggles.homeManagerModules.default];

  options.frost.home.apps.office.readers.goggles = {
    enable = lib.mkEnableOption "Github markdown renderer";
  };

  config = lib.mkIf cfg.enable {
    programs.goggles.enable = true;
  };
}
