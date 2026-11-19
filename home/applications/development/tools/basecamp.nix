{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.development.tools.basecamp;
in {
  imports = [inputs.basecamp.homeManagerModules.default];

  options.frost.home.apps.development.tools.basecamp = {
    enable = lib.mkEnableOption "Enable Single-File Nix-Shell Creator";
  };

  config = lib.mkIf cfg.enable {
    programs.basecamp.enable = true;
  };
}
