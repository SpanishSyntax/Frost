{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.security.auth.polkit;
in
{
  options.frost.security.auth = {
    polkit.enable = lib.mkEnableOption "Polkit feature set";
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;
  };
}
