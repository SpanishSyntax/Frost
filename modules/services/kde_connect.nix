{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.kde_connect;
in {
  options.frost.services.kde_connect = {
    enable = lib.mkEnableOption "kde connect for phone pairing.";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open KDE Connect port ranges (1714-1764) in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kdeconnect.enable = true;

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
