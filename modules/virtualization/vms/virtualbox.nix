{
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.vms.virtualbox;
in {
  options.frost.virtualization.vms.virtualbox.enable = lib.mkEnableOption "Virtualbox";

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
    };
  };
}
