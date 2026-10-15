{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.flaker;
in {
  imports = [inputs.flaker.homeManagerModules.default];

  options.frost.home.apps.icebergs.flaker = {
    enable = lib.mkEnableOption "Enable Single-File Nix-Shell Creator";
  };

  config = lib.mkIf cfg.enable {
    programs.flaker.enable = true;
  };
}
