{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.ssh;
in {
  options.frost.services.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable OpenSSH daemon.";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "SSH server port";
    };
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The user allowed to SSH into this machine.";
    };
    allowedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["root"] ++ lib.optional (cfg.user != null) cfg.user;
      description = "List of users allowed to connect via SSH.";
    };
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "SSH authorized public keys for the primary user.";
    };
    rootAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "SSH authorized public keys for root.";
    };
    initrdUnlock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Dropbear SSH in initrd for remote LUKS unlocking.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kitty.terminfo
    ];

    # --- Conditional Early Boot (Initrd) Remote LUKS Unlock Configuration ---
    boot.initrd.network = lib.mkIf cfg.initrdUnlock.enable {
      enable = true;
      flushBeforeStage2 = true; # Cleans up initrd network config before handing over to NetworkManager

      # Use systemd-networkd in initrd
      udhcpc.enable = false;

      ssh = {
        enable = true;
        port = 22;

        authorizedKeys =
          if cfg.user != null then
            builtins.filter
            (key: !lib.strings.hasPrefix "sk-" key)
            (config.users.users."${cfg.user}".openssh.authorizedKeys.keys or [])
          else [];

        # Nix copies this into the Nix store at build time.
        hostKeys = [
          /etc/secrets/initrd/dropbear_ed25519_host_key
        ];
      };
    };

    # --- Standard System OpenSSH Configuration ---
    services.openssh = {
      enable = true;
      ports = [cfg.port];

      # --- KEY CREATION LOGIC ---

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
        AllowUsers = cfg.allowedUsers;
      };
    };

    users.users = {
      root.openssh.authorizedKeys.keys = cfg.rootAuthorizedKeys;
    } // lib.optionalAttrs (cfg.user != null) {
      "${cfg.user}".openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };

    services.fail2ban = {
      enable = true;
      bantime = "12h";
      bantime-increment = {
        enable = true;
        rndtime = "30m";
      };
    };
  };
}
