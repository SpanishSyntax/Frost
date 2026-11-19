{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.programs.flatpak.bottles;
  flatpakEnabled = lib.hasAttr "frost" config && config.frost.programs.flatpak.enable;
in
{
  options.frost.programs.flatpak = {
    bottles.enable = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = [ "com.usebottles.bottles" ];
  };
}
