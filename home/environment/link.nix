{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.environment;
in {
  options.frost.home.environment = {
    dotfilesPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Frost/home/configs";
      description = "Base host path for out-of-store dotfile symlinking (supports hot-reloading).";
    };
  };

  config = {
    # Automatically injected into every Home Manager module via getFiles!
    _module.args.linkConfig = name:
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfilesPath}/${name}";
  };
}
