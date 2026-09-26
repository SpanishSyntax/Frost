{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.android_studio;
in {
  options.frost.home.apps.development.android_studio.enable = lib.mkEnableOption "Android Studio editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.android-studio
    ];
  };
}
