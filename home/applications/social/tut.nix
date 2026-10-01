{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.social.tut;
in {
  options.frost.home.apps.social.tut = {
    enable = lib.mkEnableOption "tut";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to flox configs for out-of-store symlinking.
        Defaults to global `frost.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tut
    ];

    xdg.configFile."tut" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/tut"
        else "${inputs.self}/home/configs/tut";
      recursive = true;
    };
  };
}
