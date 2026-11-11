{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.lightdm;
in {
  options.frost.desktop.dms.lightdm.enable = lib.mkEnableOption "LightDM";

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          greeters = {
            pantheon.enable = true;
          };
        };
      };
    };
  };
}
