{pkgs, ...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./users.nix
  ];

  boot = {
    kernelParams = [];
  };

  # Frost OS Modular Configuration
  frost = {
    system = {
      boot.console.keymap = "us";
      locale = {
        datetime.autoTimezone = true;
        fonts.enable = true;
        locales.locale = "en_US.UTF-8";
      };
      runtime.home_manager.enable = true;
    };

    hardware = {
      audio.pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
      peripherals.bluetooth.enable = true;
      power.enable = true;
    };

    network = {
      stack.networking = {
        hostname = "frost-workstation";
        backend = "networkmanager";
      };
    };

    security = {
      auth.polkit.enable = true;
      secrets.gnome_keyring.enable = true;
    };

    desktop = {
      des.gnome.enable = true;
      dms.sddm.enable = true;
      wms.hyprland.enable = true;
      portals.xdg.enable = true;
    };
  };
}
