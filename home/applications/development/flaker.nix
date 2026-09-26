{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.development.flaker;
in {
  imports = [inputs.flaker.homeManagerModules.default];

  options.frost.home.apps.development.flaker = {
    enable = lib.mkEnableOption "Enable Single-File Nix-Shell Creator";
  };

  config = lib.mkIf cfg.enable {
    programs.flaker.enable = true;
  };
}
