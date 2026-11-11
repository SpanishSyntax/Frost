{
  config,
  lib,
  ...
}: let
  cfg = config.frost.flatpak.museum;
  flatpakEnabled = lib.hasAttr "frost" config && config.frost.virtualization.flatpak.enable;
in {
  options.frost.flatpak = {
    museum.enable = lib.mkEnableOption "Museum";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = ["as.may.moat"];
  };
}
