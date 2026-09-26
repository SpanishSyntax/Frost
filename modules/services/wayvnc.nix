{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.vnc;
in {
  options.frost.services = {
    vnc.enable = lib.mkEnableOption "Wayvnc feature set";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wayvnc
    ];
  };
}
