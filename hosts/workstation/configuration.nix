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
    desktop = {
      des = {
        gnome.enable = true;
      };
      dms = {
        sddm.enable = true;
      };
      wms = {
        hyprland.enable = true;
      };
    };
    hardware = {
      bluetooth.enable = true;
      networking = {
        hostname = "frost-workstation";
        backend = "networkmanager";
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
      power.enable = true;
    };
    personalization = {
      fonts.enable = true;
      locales.locale = "en_US.UTF-8";
      xdg.enable = true;
    };
    security = {
      gnome_keyring.enable = true;
      polkit.enable = true;
    };
    system = {
      keymap = "us";
      home_manager.enable = true;
      autoTimezone = true;
    };
  };
}
