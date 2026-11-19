{
  config,
  lib,
  pkgs,
  inputs,
  wrapBin,
  ...
}: let
  cfg = config.frost.home.desktop.tools.shards;
  defaultPkg =
    if inputs ? shards
    then inputs.shards.packages.${pkgs.stdenv.hostPlatform.system}.default
    else pkgs.writeShellScriptBin "stowaway" "echo 'shards input missing'; exit 1";
  wrappedPkg = wrapBin pkgs {
    pkg = cfg.package;
    name = "shards";
    target = "stowaway";
    displayName = "Shards";
  };
in {
  options.frost.home.desktop.tools.shards = {
    enable = lib.mkEnableOption "Shards Wayland clipboard & emoji menu";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPkg;
      description = "The Shards package to use.";
    };

    systemd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to run Shards as a background systemd user service for instant overlay (<10ms).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [wrappedPkg];

    systemd.user.services.shards = lib.mkIf cfg.systemd.enable {
      Unit = {
        Description = "Shards Wayland Clipboard Daemon";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        ConditionEnvironment = "!XDG_CURRENT_DESKTOP=GNOME";
      };
      Service = {
        ExecStart = "${wrappedPkg}/bin/shards --daemon --foreground";
        Restart = "on-failure";
        RestartSec = "1s";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
