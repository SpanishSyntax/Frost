{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.ui.tools.awww;
in {
  options.frost.home.ui.tools.awww = {
    enable = lib.mkEnableOption "awww";

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
    xdg.configFile."awww" = {
      source =
        if cfg.configsPath != null
        then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/awww"
        else "${inputs.self}/home/configs/awww";
      recursive = true;
    };
    home.packages = with pkgs; [
      awww
    ];
  };
}
