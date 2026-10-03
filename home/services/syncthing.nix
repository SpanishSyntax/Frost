{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.services.syncthing;
  ignores = import ../environment/ignores.nix {inherit lib;};
  defaultDevIgnores = ignores.toSyncthing;
in {
  options.frost.home.services.syncthing = {
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
          id = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Syncthing internal Folder ID (defaults to attr name if empty).";
          };
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
          ignorePerms = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Ignore file mode/permission changes.";
          };
          useDefaultDevIgnores = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to write the standard development .stignore file into this folder.";
          };
          extraIgnores = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Additional ignore patterns to append to .stignore.";
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

        devices =
          lib.mapAttrs (name: dev: {
            inherit (dev) id autoAcceptFolders addresses;
          })
          cfg.devices;

        folders =
          lib.mapAttrs (name: folder: {
            id =
              if folder.id != ""
              then folder.id
              else name;
            inherit (folder) path devices type ignorePerms;
            versioning = {
              type = "simple";
              params.keep = toString folder.keepVersions;
            };
          })
          cfg.folders;
      };
    };

    # Automatically generate .stignore files for configured folders
    home.file = lib.mkMerge (
      lib.mapAttrsToList (
        name: folder: let
          patterns = (lib.optionals folder.useDefaultDevIgnores defaultDevIgnores) ++ folder.extraIgnores;
          relPath = lib.removePrefix "${config.home.homeDirectory}/" folder.path;
        in
          lib.mkIf (patterns != []) {
            "${relPath}/.stignore".text = lib.concatStringsSep "\n" patterns + "\n";
          }
      )
      cfg.folders
    );
  };
}
