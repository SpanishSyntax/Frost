{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.storage.trash;
in
{
  options.frost.storage = {
    trash.enable = lib.mkEnableOption "Trash";
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;
  };
}
