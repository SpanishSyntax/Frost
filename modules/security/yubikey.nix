{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.security.yubikey;
in {
  options.frost.security.yubikey = {
    enable = lib.mkEnableOption "YubiKey support & pcscd daemon";
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;
    environment.systemPackages = [
      pkgs.yubikey-manager
    ];
  };
}
