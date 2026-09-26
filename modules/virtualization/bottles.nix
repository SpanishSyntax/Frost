{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.virtualization.bottles;
  flatpakEnabled = lib.hasAttr "frost" config && config.frost.virtualization.flatpak.enable;
in
{
  options.frost.virtualization = {
    bottles.enable = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = [ "com.usebottles.bottles" ];
  };
}
