{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.sled;
  useOutOfStore = cfg.configsPath != null;
in {
  imports = [inputs.sled.homeManagerModules.default];

  options.frost.home.apps.icebergs.sled = {
    enable = lib.mkEnableOption "Enable Sled Central MCP Store & Server Bridge";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to Sled configs for out-of-store symlinking (`mkOutOfStoreSymlink`).
        Defaults to global `frost.home.environment.configsPath` (`~/Frost/home/configs`),
        allowing interactive `sled store` toggles to persist directly into your repo.
        Set to `null` to generate `~/.config/sled/sled.toml` purely from declarative `packs`, `tools`, and `settings`.
      '';
    };

    packs = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [
        "fs"
        "git"
        "system"
        "docker"
        "systemd"
        "nixos"
        "network"
      ]);
      default = [
        "fs"
        "git"
        "system"
        "docker"
        "systemd"
        "nixos"
        "network"
      ];
      description = ''
        Capability packs enabled in Sled when using pure declarative mode (`configsPath = null`).
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
        if useOutOfStore
        then null
        else cfg.packs;
      tools =
        if useOutOfStore
        then null
        else cfg.tools;
      settings =
        if useOutOfStore
        then {}
        else cfg.settings;
    };

    xdg.configFile."sled/sled.toml" = lib.mkIf useOutOfStore {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/sled/sled.toml";
    };
  };
}
