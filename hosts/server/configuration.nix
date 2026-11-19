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
    system = {
      boot.console.keymap = "us";
      locale = {
        fonts.enable = false;
        locales.locale = "en_US.UTF-8";
      };
      runtime.home_manager.enable = true;
      storage.impermanence.enable = false;
    };

    network = {
      stack.networking = {
        hostname = "frost-server";
        backend = "networkmanager";
      };
      remote.ssh = {
        user = "frost";
      };
      vpn.tailscale.enable = false;
    };

    desktop.portals.xdg.enable = false;

    virtualization = {
      containers.docker.enable = true;
    };
  };
}
