{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.power;
in {
  options.frost.hardware.power = {
    enable = lib.mkEnableOption "Power management";

    mode = lib.mkOption {
      type = lib.types.enum ["suspend" "hibernate" "suspend-then-hibernate" "hybrid-sleep" "ignore"];
      default = "suspend";
      description = "Default sleep action when closing the lid or triggering sleep.";
    };

    lidSwitch = lib.mkOption {
      type = lib.types.enum ["suspend" "hibernate" "suspend-then-hibernate" "hybrid-sleep" "ignore" "lock"];
      default = cfg.mode;
      description = "Action when closing the laptop lid on battery.";
    };

    lidSwitchExternalPower = lib.mkOption {
      type = lib.types.enum ["suspend" "hibernate" "suspend-then-hibernate" "hybrid-sleep" "ignore" "lock"];
      default = cfg.mode;
      description = "Action when closing the laptop lid while connected to AC power.";
    };

    lidSwitchDocked = lib.mkOption {
      type = lib.types.enum ["suspend" "hibernate" "suspend-then-hibernate" "hybrid-sleep" "ignore" "lock"];
      default = "ignore";
      description = "Action when closing the laptop lid while connected to an external display (clamshell mode).";
    };

    hibernation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default =
          cfg.mode
          == "hibernate"
          || cfg.mode == "suspend-then-hibernate"
          || cfg.lidSwitch == "hibernate"
          || cfg.lidSwitch == "suspend-then-hibernate";
        description = "Enable kernel resume support for hibernation.";
      };

      resumeDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Partition or device mapper containing swap for resume.";
      };

      resumeOffset = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Swapfile physical block offset (for Btrfs/Ext4 swapfiles).";
      };

      delaySec = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "1800";
        example = "1800";
        description = "HibernateDelaySec for suspend-then-hibernate (defaults to 30 minutes).";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      powerManagement.enable = true;

      services.logind.settings.Login = {
        HandleLidSwitch = cfg.lidSwitch;
        HandleLidSwitchExternalPower = cfg.lidSwitchExternalPower;
        HandleLidSwitchDocked = cfg.lidSwitchDocked;
      };
    }

    (lib.mkIf cfg.hibernation.enable {
      boot.resumeDevice = lib.mkIf (cfg.hibernation.resumeDevice != null) cfg.hibernation.resumeDevice;

      boot.kernelParams = lib.optional (cfg.hibernation.resumeOffset != null) "resume_offset=${toString cfg.hibernation.resumeOffset}";

      systemd.sleep.settings.Sleep = lib.mkIf (cfg.hibernation.delaySec != null) {
        HibernateDelaySec = cfg.hibernation.delaySec;
      };
    })
  ]);
}
