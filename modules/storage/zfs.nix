{
  config,
  lib,
  ...
}: let
  cfg = config.frost.storage.zfs;
in {
  options.frost.storage.zfs = {
    enable = lib.mkEnableOption "ZFS Support";
    extraPools = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of extra ZFS pools to import automatically on boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.networking.hostId != null;
        message = "ZFS requires a 32-bit hostId to be set via frost.hardware.networking.hostId (or networking.hostId).";
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
  };
}
