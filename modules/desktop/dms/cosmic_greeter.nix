{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.cosmic_greeter;
in {
  options.frost.desktop.dms.cosmic_greeter = {
    enable = lib.mkEnableOption "COSMIC Greeter display manager";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;

    frost.desktop.dms.defaultSession =
      lib.mkIf (config.frost.desktop.des.cosmic.enable or false) (lib.mkDefault "cosmic");
  };
}
