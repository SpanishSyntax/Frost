{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.vnc;
in {
  options.frost.services.vnc = {
    enable = lib.mkEnableOption "Wayvnc VNC server for Wayland";

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically start wayvnc when the graphical session starts.";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        IP address on which wayvnc listens. Default is "0.0.0.0" (all interfaces).
        When accessing exclusively through Tailscale, this can safely remain "0.0.0.0"
        with `openFirewall = false` because 'tailscale0' is a trusted interface in Frost.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5900;
      description = "TCP port on which wayvnc listens.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the VNC port in the public firewall.
        Defaults to false. When using Tailscale, keep this false: Frost configures
        'tailscale0' as a trusted interface, allowing direct peer connections without
        punching open ports to external/public networks.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to an explicit wayvnc configuration file. If null, wayvnc defaults to ~/.config/wayvnc/config.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["--render-cursor" "--max-fps=60"];
      description = "Extra command-line arguments to pass to wayvnc.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wayvnc
    ];

    # Open firewall port (optional; unneeded when accessing via Tailscale)
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];

    # Systemd user service running within the Wayland graphical session
    systemd.user.services.wayvnc = {
      description = "Wayvnc VNC server for Wayland";
      documentation = ["man:wayvnc(1)"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.concatStringsSep " " (
          ["${pkgs.wayvnc}/bin/wayvnc"]
          ++ lib.optional (cfg.configFile != null) "-C ${cfg.configFile}"
          ++ (lib.map lib.escapeShellArg cfg.extraArgs)
          ++ ["${cfg.address}:${toString cfg.port}"]
        );
        Restart = "on-failure";
        RestartSec = 2;
      };

      wantedBy = lib.mkIf cfg.autoStart ["graphical-session.target"];
    };

    # Impermanence persistence for system-wide Wayvnc configurations / certificates
    frost.storage.impermanence.directories = [
      "/etc/wayvnc"
    ];
  };
}
