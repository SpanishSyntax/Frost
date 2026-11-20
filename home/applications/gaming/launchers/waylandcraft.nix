{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.gaming.launchers.waylandcraft;

  waylandcraftJar = pkgs.fetchurl {
    url = "https://github.com/EVV1E/waylandcraft/releases/download/v${cfg.version}/waylandcraft-v${cfg.version}.jar";
    hash = cfg.hash;
  };
in {
  options.frost.home.apps.gaming.launchers.waylandcraft = {
    enable = lib.mkEnableOption "Waylandcraft (Wayland compositor inside Minecraft Fabric mod + Prism Launcher & xwayland-satellite)";

    version = lib.mkOption {
      type = lib.types.str;
      default = "2.1.0";
      description = "Waylandcraft mod release version.";
    };

    hash = lib.mkOption {
      type = lib.types.str;
      default = "sha256-jMR2DESpj8FlLLUBM6TZoNr7i0QTEb1bkZlMqfjFzdo=";
      description = "SRI hash of the Waylandcraft release JAR.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
      libxkbcommon
      xwayland-satellite
    ];

    # Place the mod JAR in a predictable location ready to drop into a Prism Launcher Fabric instance
    xdg.dataFile."waylandcraft/waylandcraft-v${cfg.version}.jar".source = waylandcraftJar;
  };
}
