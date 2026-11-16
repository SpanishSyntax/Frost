{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.fjord;
in {
  imports = [inputs.fjord.homeManagerModules.default];

  options.frost.home.apps.icebergs.fjord = {
    enable = lib.mkEnableOption "Fjord (Wormhole) Material 3 XDG Desktop Portal daemon & dialogs";
  };

  config = lib.mkIf cfg.enable {
    programs.fjord.enable = true;
  };
}
