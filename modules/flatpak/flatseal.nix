{
  config,
  lib,
  ...
}: let
  cfg = config.frost.flatpak.flatseal;
  flatpakEnabled = lib.hasAttr "frost" config && config.frost.virtualization.flatpak.enable;
in {
  options.frost.flatpak = {
    flatseal.enable = lib.mkEnableOption "Flatseal";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = ["com.github.tchx84.Flatseal"];
  };
}
