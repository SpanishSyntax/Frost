{
  config,
  lib,
  pkgs,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.shards;
  pkg =
    if inputs ? shards
    then inputs.shards.packages.${pkgs.stdenv.hostPlatform.system}.default
    else pkgs.writeShellScriptBin "stowaway" "echo 'shards input missing'; exit 1";
in {
  options.frost.home.apps.icebergs.shards = {
    enable = lib.mkEnableOption "Shards Wayland clipboard & emoji menu";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      description = "The Shards package to use.";
    };
    daemon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to run Shards as a background daemon for instant overlay (<10ms).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (wrapBin pkgs {
        pkg = cfg.package;
        name = "shards";
        target = "stowaway";
        displayName = "Shards";
      })
    ];

    systemd.user.services.shards = lib.mkIf cfg.daemon.enable {
      Unit = {
        Description = "Shards Wayland Clipboard Daemon";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${cfg.package}/bin/stowaway --daemon --foreground";
        Restart = "on-failure";
        RestartSec = "1s";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
