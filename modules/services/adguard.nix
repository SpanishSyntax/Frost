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

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open DNS (port 53) and Web UI port globally in firewall instead of restricting to allowedSubnets.";
    };

    allowedSubnets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["192.168.0.1/24"];
      description = "Subnets allowed to query DNS and access the Web UI when openFirewall is false.";
    };

    bootstrapDns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "9.9.9.9"
        "1.1.1.2"
      ];
      description = "Bootstrap DNS servers used to resolve upstream DoH/DoT resolvers.";
    };

    upstreamDns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "https://dns.quad9.net/dns-query"
        "https://security.cloudflare-dns.com/dns-query"
      ];
      description = "Upstream DNS resolvers for queries.";
    };

    upstreamMode = lib.mkOption {
      type = lib.types.enum ["fastest_addr" "parallel" "load_balance"];
      default = "fastest_addr";
      description = "Upstream DNS query resolution mode (fastest_addr, parallel, or load_balance).";
    };

    filtering = {
      protection = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable general protection and filter lists.";
      };

      parental = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable parental control (blocking adult domains).";
      };

      safeSearch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enforce SafeSearch across search engines (Google, YouTube, Bing, etc.).";
      };
    };

    filters = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.str (lib.types.attrsOf lib.types.anything));
      default = [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
      ];
      description = "List of blocklist URLs or filter attribute sets ({ name, url, enabled }).";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Extra settings merged into services.adguardhome.settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    # frost.storage.impermanence.directories = [
    #   {
    #     directory = "/var/lib/private/AdGuardHome";
    #     mode = "0700";
    #   }
    # ];

    systemd.tmpfiles.rules = [
      "d /var/lib/private 0700 root root -"
      "z /var/lib/private 0700 root root -"
    ];

    services.resolved.settings = {
      Resolve = {
        DNSStubListener = "no";
      };
    };

    networking.firewall.extraInputRules = lib.mkIf (!cfg.openFirewall) (
      lib.mkAfter (lib.concatMapStringsSep "\n" (subnet: ''
          # Allow local network to query DNS and access Web UI
          ip saddr ${subnet} tcp dport { 53, ${toString cfg.port} } accept
          ip saddr ${subnet} udp dport 53 accept
        '')
        cfg.allowedSubnets)
    );

    services.adguardhome = {
      enable = true;
      openFirewall = cfg.openFirewall;
      host = "0.0.0.0";
      port = cfg.port;
      settings =
        lib.recursiveUpdate {
          dns = {
            bootstrap_dns = cfg.bootstrapDns;
            upstream_dns = cfg.upstreamDns;
            upstream_mode = cfg.upstreamMode;
          };
          filtering = {
            protection_enabled = cfg.filtering.protection;
            filtering_enabled = cfg.filtering.protection;
            parental_enabled = cfg.filtering.parental;
            safe_search = {
              enabled = cfg.filtering.safeSearch;
            };
          };
          filters =
            map (
              f:
                if builtins.isString f
                then {
                  enabled = true;
                  url = f;
                }
                else f
            )
            cfg.filters;
        }
        cfg.extraSettings;
    };
  };
}
