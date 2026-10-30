{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.system.plymouth;
in {
  options.frost.system.plymouth = {
    enable = lib.mkEnableOption "Plymouth boot splash animation";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "rings";
      description = "Selected Plymouth theme name.";
    };

    themePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [cfg.theme];
        })
      ];
      description = "Extra theme packages to install for Plymouth.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      boot.plymouth = {
        enable = true;
        inherit (cfg) theme themePackages;
      };
    })

    (lib.mkIf (cfg.enable || (config.boot.plymouth.enable or false)) {
      frost.storage.impermanence.directories = [
        "/var/lib/plymouth"
      ];
    })
  ];
}
