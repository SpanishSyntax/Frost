{
  config,
  lib,
  ...
}: let
  cfg = config.frost.virtualization.virtualbox;
in {
  options.frost.virtualization.virtualbox.enable = lib.mkEnableOption "Virtualbox";

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;
    };
  };
}
