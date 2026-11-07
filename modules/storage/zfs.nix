{
  config,
  lib,
  ...
}: let
  cfg = config.frost.storage.zfs;
  netCfg = config.frost.hardware.networking;
  effectiveHostId =
    if cfg.hostId != null
    then cfg.hostId
    else netCfg.hostId;
in {
  options.frost.storage.zfs = {
    enable = lib.mkEnableOption "ZFS Support";
    hostId = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "[0-9a-fA-F]{8}");
      default = null;
      example = "007f0200";
      description = "The unique 32-bit host identifier (8 hex characters) required for ZFS pool protection. Defaults to frost.hardware.networking.hostId.";
    };
    extraPools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of extra ZFS pools to import automatically on boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = effectiveHostId != null || config.networking.hostId != null;
        message = "ZFS requires a 32-bit hostId to be set via frost.hardware.networking.hostId or frost.storage.zfs.hostId.";
      }
    ];

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

    networking.hostId = lib.mkIf (effectiveHostId != null) (lib.mkDefault effectiveHostId);
  };
}
