{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.shards;
in {
  imports = [inputs.shards.homeManagerModules.default];

  options.frost.home.apps.icebergs.shards = {
    enable = lib.mkEnableOption "Quickshell paste and emoji menu";
  };

  config = lib.mkIf cfg.enable {
    programs.shards.enable = true;
  };
}
