{
  config,
  lib,
  ...
}: let
  cfg = config.frost.storage.zfs;
in {
  options.frost.storage.zfs = {
    enable = lib.mkEnableOption "ZFS Support";
    hostId = lib.mkOption {
      type = lib.types.strMatching "[0-9a-fA-F]{8}";
      example = "007f0200";
      description = "The unique 32-bit host identifier (8 hex characters) required for ZFS pool protection.";
    };
    extraPools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of extra ZFS pools to import automatically on boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      supportedFilesystems = ["zfs"];
      zfs = {
        forceImportRoot = false;
        inherit (cfg) extraPools;
      };
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    networking.hostId = cfg.hostId;
  };
}
