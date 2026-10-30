{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.tailscale;
in {
  options.frost.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale feature set";
    port = lib.mkOption {
      type = lib.types.port;
      default = 41641;
      description = "The UDP port on which Tailscale listens.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open the Tailscale UDP port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      port = cfg.port;
    };

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = lib.mkIf cfg.openFirewall [cfg.port];
    };

    frost.storage.impermanence.directories = [
      "/var/lib/tailscale"
    ];
  };
}
