{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.storage.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options.frost.storage.impermanence = {
    enable = lib.mkEnableOption "Impermanence layer";
    persistPath = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Root mount path for persistent storage.";
    };
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [];
      description = "Directories to persist across boots.";
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [];
      description = "Files to persist across boots.";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."${cfg.persistPath}".neededForBoot = true;

    environment.persistence."${cfg.persistPath}" = {
      hideMounts = true;
      directories =
        [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
        ]
        ++ cfg.directories;

      files =
        [
          "/etc/machine-id"
        ]
        ++ cfg.files;
    };
  };
}
