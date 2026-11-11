{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.security.polkit;
in
{
  options.frost.security = {
    polkit.enable = lib.mkEnableOption "Polkit feature set";
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;
  };
}
