{
  config,
  lib,
  ...
}: let
  cfg = config.frost.programs.flatpak.museum;
  flatpakEnabled = lib.hasAttr "frost" config && config.frost.programs.flatpak.enable;
in {
  options.frost.programs.flatpak = {
    museum.enable = lib.mkEnableOption "Museum";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = ["as.may.moat"];
  };
}
