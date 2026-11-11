{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.sled;
  hasConfigs = config.frost.home.environment.configsPath != null;
in {
  imports = [inputs.sled.homeManagerModules.default];

  options.frost.home.apps.icebergs.sled = {
    enable = lib.mkEnableOption "Enable Sled Central MCP Store & Server Bridge";

    packs = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [
        "fs"
        "git"
        "system"
        "docker"
        "systemd"
        "nixos"
        "network"
        "dev"
      ]);
      default = [];
      description = ''
        Capability packs enabled in Sled when using pure declarative mode (`configsPath = null`).
        Defaults to empty (zero-trust: no tools exposed until explicitly whitelisted).
      '';
    };

    tools = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      example = ["ls" "cat" "grep" "git_status" "docker_ps" "journalctl"];
      description = ''
        Specific atomic MCP tools to enable when using pure declarative mode (`configsPath = null`).
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        Additional TOML settings merged into `~/.config/sled/sled.toml` when `configsPath = null`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.sled = {
      enable = true;
      packs =
        if hasConfigs
        then null
        else cfg.packs;
      tools =
        if hasConfigs
        then null
        else cfg.tools;
      settings =
        if hasConfigs
        then {}
        else cfg.settings;
    };

    xdg.configFile."sled" = lib.mkIf hasConfigs {
      source = config.frost.home.environment.mkSource "sled";
      recursive = true;
    };
  };
}
