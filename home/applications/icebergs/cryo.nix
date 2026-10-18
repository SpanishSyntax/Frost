{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.cryo;
in {
  imports = [inputs.cryo.homeManagerModules.default];

  options.frost.home.apps.icebergs.cryo = {
    enable = lib.mkEnableOption "Enable Cryo Central MCP Server Bridge";
  };

  config = lib.mkIf cfg.enable {
    programs.cryo.enable = true;
  };
}
