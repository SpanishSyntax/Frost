{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.desktop.dms.sddm;

  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "japanese_aesthetic";
  };
in {
  options.frost.desktop.dms.sddm.enable = lib.mkEnableOption "SDDM";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
        enableHidpi = true;
        theme = "sddm-astronaut-theme";
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
            CursorTheme = "Bibata-Modern-Ice";
            CursorSize = 24;
          };
          Users = {
            RememberLastUser = true;
          };
        };
        extraPackages = with pkgs; [
          custom-sddm-astronaut
        ];
      };
    };
    environment.systemPackages = with pkgs; [
      custom-sddm-astronaut
      kdePackages.qtmultimedia
    ];
  };
}
