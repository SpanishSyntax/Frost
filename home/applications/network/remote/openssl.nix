{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.network.remote.openssl;
in {
  options.frost.home.apps.network.remote.openssl.enable = lib.mkEnableOption "Openssl";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.openssl
    ];
  };
}
