{
  config,
  lib,
  ...
}: let
  cfg = config.frost.services.tailscale;
in {
  options.frost.services = {
    tailscale.enable = lib.mkEnableOption "Tailscale feature set";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
