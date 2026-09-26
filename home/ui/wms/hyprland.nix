{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  cfg = config.frost.home.ui.wms.hyprland;
in {
  options.frost.home.ui.wms = {
    hyprland = {
      enable = lib.mkEnableOption "Hyprland feature set";
    };
  };

  config = lib.mkIf cfg.enable {
    # Packages & Dependencies
    home.packages = with pkgs;
      [
        hyprpolkitagent
      ]
      ++ lib.optionals (host == "laptop") [];
  };
}
