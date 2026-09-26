{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.openssl;
in {
  options.frost.home.apps.networking.openssl.enable = lib.mkEnableOption "Openssl";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.openssl
    ];
  };
}
