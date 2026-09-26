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
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [];
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/persist".neededForBoot = true;

    environment.persistence."/persist" = {
      hideMounts = true;
      directories =
        [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/fail2ban"
          "/var/lib/systemd/coredump"
        ]
        ++ cfg.directories;

      files =
        [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/secrets/initrd/dropbear_ed25519_host_key"
          "/etc/secrets/initrd/dropbear_ed25519_host_key.pub"
        ]
        ++ cfg.files;
    };
  };
}
