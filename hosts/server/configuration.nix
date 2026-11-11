{...}: {
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
    hardware = {
      networking = {
        hostname = "frost-server";
        backend = "networkmanager";
      };
    };
    personalization = {
      fonts.enable = false;
      locales.locale = "en_US.UTF-8";
      xdg.enable = false;
    };
    services = {
      ssh = {
        user = "frost";
      };
      tailscale.enable = false;
    };
    storage = {
      impermanence = {
        enable = false;
      };
    };
    system = {
      keymap = "us";
      home_manager.enable = true;
    };
    virtualization = {
      docker.enable = true;
    };
  };
}
