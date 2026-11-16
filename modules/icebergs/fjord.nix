{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.icebergs.fjord;
in {
  imports = [
    inputs.fjord.nixosModules.default
  ];

  options.frost.icebergs = {
    fjord = {
      enable = lib.mkEnableOption "Fjord (Wormhole) Material 3 XDG desktop portal integration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fjord.enable = true;
  };
}
