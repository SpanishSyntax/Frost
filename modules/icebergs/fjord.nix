{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.icebergs.fjord;
in {
  options.frost.icebergs = {
    fjord = {
      enable = lib.mkEnableOption "Fjord (Wormhole) Material 3 XDG desktop portal integration";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optional (inputs ? fjord) inputs.fjord.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
