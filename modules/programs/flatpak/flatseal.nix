{
  config,
  lib,
  ...
}: let
  cfg = config.frost.programs.flatpak.flatseal;
  flatpakEnabled = lib.hasAttr "frost" config && config.frost.programs.flatpak.enable;
in {
  options.frost.programs.flatpak = {
    flatseal.enable = lib.mkEnableOption "Flatseal";
  };

  config = lib.mkIf (flatpakEnabled && cfg.enable) {
    services.flatpak.packages = ["com.github.tchx84.Flatseal"];
  };
}
