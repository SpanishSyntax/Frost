{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.basecamp;
in {
  imports = [inputs.basecamp.homeManagerModules.default];

  options.frost.home.apps.icebergs.basecamp = {
    enable = lib.mkEnableOption "Enable Single-File Nix-Shell Creator";
  };

  config = lib.mkIf cfg.enable {
    programs.basecamp.enable = true;
  };
}
