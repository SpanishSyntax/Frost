{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  cfg = config.frost.security.pam;

in {
  options.frost.security.pam = {
    enable = lib.mkEnableOption "PAM Yubi feature set";
    sopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "SOPS file containing the PAM U2F authentication key.";
    };
    u2fKey = lib.mkOption {
      type = lib.types.str;
      default = if host != null then "u2f_keys_${host}" else "u2f_keys";
      description = "SOPS secret key name for PAM U2F authentication.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.yubikey-touch-detector.enable = true;

    systemd.user.services.yubikey-touch-detector = {
      serviceConfig.ExecStart = [
        "" # This clears the default package command configuration line
        "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify"
      ];
    };

    sops.secrets.u2f_keys = lib.mkIf (cfg.sopsFile != null) {
      mode = "0444";
      sopsFile = cfg.sopsFile;
      key = cfg.u2fKey;
    };

    security.pam.u2f = {
      enable = true;
      settings = {
        cue = true;
        interactive = true;
      } // lib.optionalAttrs (cfg.sopsFile != null) {
        authfile = config.sops.secrets.u2f_keys.path;
      };
    };

    security.pam.services = {
      sudo.u2fAuth = true;
    };
  };
}
