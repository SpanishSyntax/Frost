{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.hardware.sensors.wluma;
  tomlFormat = pkgs.formats.toml {};
in {
  options.frost.hardware.sensors.wluma = {
    enable = lib.mkEnableOption "wluma Wayland automatic brightness daemon (ALS + screen content)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wluma;
      description = "The wluma package to use.";
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = {};
      description = ''
        Optional TOML configuration written to `/etc/xdg/wluma/config.toml`.
        When empty, wluma uses its built-in auto-detecting defaults for ALS and backlight.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    frost.hardware.sensors.iio.enable = lib.mkDefault true;

    environment.systemPackages = [cfg.package];

    # Allow the active seat user and `video` group to write sysfs backlight brightness
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness", TAG+="uaccess"
      ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness", TAG+="uaccess"
    '';

    environment.etc."xdg/wluma/config.toml" = lib.mkIf (cfg.settings != {}) {
      source = tomlFormat.generate "wluma-config.toml" cfg.settings;
    };

    systemd.user.services.wluma = {
      description = "wluma automatic Wayland display brightness daemon";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = [
        "WAYLAND_DISPLAY"
        "!XDG_CURRENT_DESKTOP=GNOME"
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/wluma";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
