{
  config,
  lib,
  pkgs,
  ...
}: {
  options.frost.home.environment = {
    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "${config.home.homeDirectory}/Frost/home/configs";
      example = null;
      description = ''
        Global filesystem base path for dotfile configs.
        Set to `null` to disable out-of-store symlinking across all apps.
      '';
    };
  };
}
