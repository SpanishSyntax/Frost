{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.security.auth.yubikey;
in {
  options.frost.security.auth.yubikey = {
    enable = lib.mkEnableOption "YubiKey support & pcscd daemon";
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;
    environment.systemPackages = [
      pkgs.yubikey-manager
    ];
  };
}
