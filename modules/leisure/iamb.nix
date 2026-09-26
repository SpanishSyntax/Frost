{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.leisure.iamb;
in {
  options.frost.leisure.iamb = {
    enable = lib.mkEnableOption "Iamb - Ultimate TUI Chat Dashboard Stack";
  };

  config = lib.mkIf cfg.enable {
    users.users.matrix-conduit = {
      isSystemUser = true;
      group = "matrix-conduit";
      uid = 888;
    };
    users.groups.matrix-conduit.gid = 888;

    services.matrix-conduit = {
      enable = true;
      settings.global = {
        server_name = "localhost";
        port = 6167;
        address = "127.0.0.1";
        allow_registration = true;
      };
    };

    services.heisenbridge = {
      enable = true;
      homeserver = "http://localhost:6167";
    };

    environment.systemPackages = [
      pkgs.iamb
    ];
  };
}
