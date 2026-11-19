{
  config,
  lib,
  ...
}: let
  cfg = config.frost.network.sync.syncthing;
in {
  options.frost.network.sync.syncthing = {
    enable = lib.mkEnableOption "Syncthing feature set";
    user = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "User to run Syncthing as.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group to run Syncthing as.";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = if cfg.user != "" then "/home/${cfg.user}/.config/syncthing" else "/var/lib/syncthing";
      description = "Data directory for Syncthing.";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = if cfg.user != "" then "/home/${cfg.user}/.config/syncthing" else "/var/lib/syncthing";
      description = "Configuration directory for Syncthing.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != "";
        message = "frost.network.sync.syncthing.user must be specified when Syncthing is enabled.";
      }
    ];

    services.syncthing = {
      enable = true;
      inherit (cfg) user group dataDir configDir;
      openDefaultPorts = true;
    };
  };
}
