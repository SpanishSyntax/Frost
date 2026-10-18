{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.cryo;
  useOutOfStore = cfg.configsPath != null;
in {
  imports = [inputs.cryo.homeManagerModules.default];

  options.frost.home.apps.icebergs.cryo = {
    enable = lib.mkEnableOption "Enable Cryo Central MCP Store & Server Bridge";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to Cryo configs for out-of-store symlinking (`mkOutOfStoreSymlink`).
        Defaults to global `frost.home.environment.configsPath` (`~/Frost/home/configs`),
        allowing interactive `cryo store` toggles to persist directly into your repo.
        Set to `null` to generate `~/.config/cryo/cryo.toml` purely from declarative `packs` and `settings`.
      '';
    };

    packs = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [
        "core"
        "docker"
        "systemd"
        "nixos"
        "network"
        "external"
      ]);
      default = [
        "core"
        "docker"
        "systemd"
        "nixos"
        "network"
        "external"
      ];
      description = ''
        Capability packs enabled in Cryo when using pure declarative mode (`configsPath = null`).
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        Additional TOML settings merged into `~/.config/cryo/cryo.toml` when `configsPath = null`
        (e.g. `external.servers.<name>` definitions).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.cryo = {
      enable = true;
      packs =
        if useOutOfStore
        then null
        else cfg.packs;
      settings =
        if useOutOfStore
        then {}
        else cfg.settings;
    };

    xdg.configFile."cryo/cryo.toml" = lib.mkIf useOutOfStore {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/cryo/cryo.toml";
    };
  };
}
