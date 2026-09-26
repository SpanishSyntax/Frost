{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.adguard;
in {
  options.frost.services.adguard = {
    enable = lib.mkEnableOption "AdGuard Home feature set";
  };

  config = lib.mkIf cfg.enable {
    services.resolved.settings = {
      Resolve = {
        DNSStubListener = "no";
      };
    };

    networking.firewall.extraInputRules = lib.mkAfter ''
      # Allow local network to query DNS and access Web UI
      ip saddr 192.168.2.0/24 tcp dport { 53, 9998 } accept
      ip saddr 192.168.2.0/24 udp dport 53 accept
    '';
    services.adguardhome = {
      enable = true;
      openFirewall = false;
      host = "0.0.0.0";
      port = 9998;
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
