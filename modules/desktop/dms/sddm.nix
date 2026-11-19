{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.sddm;

  astronautPkg = lib.optional (cfg.astronautTheme != null) (
    pkgs.sddm-astronaut.override {
      embeddedTheme = cfg.astronautTheme;
    }
  );
in {
  options.frost.desktop.dms.sddm = {
    enable = lib.mkEnableOption "SDDM display manager";

    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run SDDM on Wayland.";
    };

    autoNumlock = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NumLock automatically at login.";
    };

    enableHidpi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable HiDPI scaling for SDDM.";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "sddm-astronaut-theme";
      description = "SDDM theme name.";
    };

    astronautTheme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "astronaut";
      example = "japanese_aesthetic";
      description = "Embedded sddm-astronaut preset theme (set null to disable installing sddm-astronaut).";
    };

    cursorTheme = lib.mkOption {
      type = lib.types.str;
      default = "Bibata-Modern-Ice";
      description = "Cursor theme used in SDDM.";
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size used in SDDM.";
    };

    rememberLastUser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Remember the last logged-in user.";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional packages exposed to SDDM themes.";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      description = "Extra SDDM settings merged into `services.displayManager.sddm.settings`.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = cfg.wayland;
        autoNumlock = cfg.autoNumlock;
        enableHidpi = cfg.enableHidpi;
        theme = cfg.theme;
        settings = lib.recursiveUpdate {
          Theme = {
            Current = cfg.theme;
            CursorTheme = cfg.cursorTheme;
            CursorSize = cfg.cursorSize;
          };
          Users = {
            RememberLastUser = cfg.rememberLastUser;
          };
        } cfg.extraSettings;
        extraPackages = astronautPkg ++ cfg.extraPackages;
      };
    };

    environment.systemPackages =
      astronautPkg
      ++ lib.optional (cfg.astronautTheme != null) pkgs.kdePackages.qtmultimedia;

    frost.desktop.dms.defaultSession =
      lib.mkIf (config.frost.desktop.des.plasma.enable or false) (lib.mkDefault "plasma");

    frost.storage.impermanence.directories = [
      "/var/lib/sddm"
    ];
  };
}
