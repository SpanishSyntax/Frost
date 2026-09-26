{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  cfg = config.frost.security.sops_nix;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.frost.security.sops_nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SOPS-nix secret management.";
    };

    defaultSopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "The default path to the encrypted SOPS file.";
    };

    keyFile = lib.mkOption {
      type = lib.types.str;
      default =
        if config.frost.storage.impermanence.enable or false
        then "/persist/etc/sops/identities.txt"
        else "/etc/sops/identities.txt";
      description = "Path to the age identities file.";
    };

    sshKeyPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        (
          if config.frost.storage.impermanence.enable or false
          then "/persist/etc/ssh/ssh_host_ed25519_key"
          else "/etc/ssh/ssh_host_ed25519_key"
        )
      ];
      description = "Paths to SSH host keys for age decryption.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sops
      pkgs.age
      pkgs.age-plugin-yubikey
    ];

    environment.sessionVariables = {
      SOPS_AGE_KEY_FILE = cfg.keyFile;
    };

    sops = {
      defaultSopsFile = lib.mkIf (cfg.defaultSopsFile != null) cfg.defaultSopsFile;

      age = {
        keyFile = cfg.keyFile;
        generateKey = true;
        plugins = [pkgs.age-plugin-yubikey];

        inherit (cfg) sshKeyPaths;
      };

      validateSopsFiles = false;
    };
  };
}
