{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.system.sops;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.frost.home.apps.system.sops = {
    enable = lib.mkEnableOption "SOPS user secrets integration";
    defaultSopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Default encrypted SOPS file for user.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = lib.mkIf (cfg.defaultSopsFile != null) cfg.defaultSopsFile;

      age = {
        keyFile = "/persist/etc/sops/identities.txt";
        plugins = [pkgs.age-plugin-yubikey];

        sshKeyPaths = [
          "/persist/etc/ssh/ssh_host_ed25519_key"
        ];
      };
    };
  };
}
