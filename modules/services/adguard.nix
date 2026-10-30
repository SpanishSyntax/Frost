{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.adguard;
in {
  options.frost.services.adguard = {
    enable = lib.mkEnableOption "AdGuard Home feature set";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9998;
      description = "Web UI port for AdGuard Home.";
    };

    allowedSubnets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["192.168.0.1/24"];
      description = "Subnets allowed to query DNS and access the Web UI.";
    };
  };

  config = lib.mkIf cfg.enable {
    frost.storage.impermanence.directories = [
      "/var/lib/AdGuardHome"
    ];

    services.resolved.settings = {
      Resolve = {
        DNSStubListener = "no";
      };
    };

    networking.firewall.extraInputRules = lib.mkAfter (lib.concatMapStringsSep "\n" (subnet: ''
        # Allow local network to query DNS and access Web UI
        ip saddr ${subnet} tcp dport { 53, ${toString cfg.port} } accept
        ip saddr ${subnet} udp dport 53 accept
      '')
      cfg.allowedSubnets);

    services.adguardhome = {
      enable = true;
      openFirewall = false;
      host = "0.0.0.0";
      port = cfg.port;
      settings = {
        dns = {
          bootstrap_dns = [
            "9.9.9.9"
            "1.1.1.2"
          ];
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "https://dns.mullvad.net/dns-query"
            "https://security.cloudflare-dns.com/dns-query"
          ];
          upstream_mode = "fastest_addr";
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = true;
          safe_search = {
            enabled = true;
          };
        };
        filters =
          map (url: {
            enabled = true;
            url = url;
          }) [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
          ];
      };
    };
  };
}
