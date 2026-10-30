{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.power;
in {
  options.frost.hardware.power = {
    enable = lib.mkEnableOption "Power management";

    hibernation = {
      enable = lib.mkEnableOption "Hibernation / Resume support";

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
        default = null;
        example = "1800";
        description = "HibernateDelaySec for suspend-then-hibernate.";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      powerManagement.enable = true;
    }

    (lib.mkIf cfg.hibernation.enable {
      boot.resumeDevice = lib.mkIf (cfg.hibernation.resumeDevice != null) cfg.hibernation.resumeDevice;

      boot.kernelParams = lib.optional (cfg.hibernation.resumeOffset != null) "resume_offset=${toString cfg.hibernation.resumeOffset}";

      systemd.sleep.extraConfig = lib.optionalString (cfg.hibernation.delaySec != null) ''
        HibernateDelaySec=${cfg.hibernation.delaySec}
      '';
    })
  ]);
}
