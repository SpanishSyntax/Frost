{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.networking.syncthing;
in {
  options.frost.home.apps.networking.syncthing = {
    enable = lib.mkEnableOption "Frost Syncthing user service";

    tray = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop tray icon integration.";
    };

    devices = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          id = lib.mkOption {
            type = lib.types.str;
            description = "Syncthing Device ID.";
          };
          autoAcceptFolders = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Automatically accept shared folders from this device.";
          };
          addresses = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["dynamic"];
            description = "List of network addresses to discover or connect to.";
          };
        };
      });
      default = {};
      description = "Declared remote Syncthing devices.";
    };

    folders = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            description = "Local path of the directory to sync.";
          };
          devices = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of devices to share this folder with.";
          };
          type = lib.mkOption {
            type = lib.types.enum ["sendreceive" "sendonly" "receiveonly"];
            default = "sendreceive";
            description = "Sync folder mode.";
          };
          keepVersions = lib.mkOption {
            type = lib.types.ints.positive;
            default = 5;
            description = "Number of old versions to retain (simple versioning).";
          };
        };
      });
      default = {};
      description = "Declared synchronized folders.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = cfg.tray;

      settings = {
        options = {
          urAccepted = -1; # Disable anonymous usage reporting
          relaysEnabled = true;
        };

        # Map custom device options directly
        devices =
          lib.mapAttrs (name: dev: {
            inherit (dev) id autoAcceptFolders addresses;
          })
          cfg.devices;

        # Map custom folder options and inject standard versioning
        folders =
          lib.mapAttrs (name: folder: {
            inherit (folder) path devices type;
            versioning = {
              type = "simple";
              params.keep = toString folder.keepVersions;
            };
          })
          cfg.folders;
      };
    };
  };
}
