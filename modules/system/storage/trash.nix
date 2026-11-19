{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.system.storage.trash;
in
{
  options.frost.system.storage = {
    trash.enable = lib.mkEnableOption "Trash";
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;
  };
}
