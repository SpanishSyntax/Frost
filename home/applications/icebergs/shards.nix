{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.shards;
  pkg =
    if inputs ? shards
    then inputs.shards.packages.${pkgs.stdenv.hostPlatform.system}.default
    else pkgs.writeShellScriptBin "stowaway" "echo 'shards input missing'; exit 1";
in {
  options.frost.home.apps.icebergs.shards = {
    enable = lib.mkEnableOption "Quickshell paste and emoji menu";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      description = "The Stowaway package to use.";
    };
    daemon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to run Stowaway as a background daemon for instant overlay (<10ms).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.symlinkJoin {
        name = "shards-wrapped";
        paths = [
          (pkgs.writeShellScriptBin "shards" ''
            exec ${cfg.package}/bin/stowaway "$@"
          '')
          cfg.package
        ];
      })
    ];

    systemd.user.services.stowaway = lib.mkIf cfg.daemon.enable {
      Unit = {
        Description = "Stowaway Wayland Clipboard Daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${cfg.package}/bin/stowaway --daemon --foreground";
        Restart = "on-failure";
        RestartSec = "1s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
