{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.frost.security.secrets.gnome_keyring;
in
{
  options.frost.security.secrets = {
    gnome_keyring.enable = lib.mkEnableOption "Keyring feature set";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-keyring
    ];
    services.gnome.gnome-keyring.enable = true;
  };
}
