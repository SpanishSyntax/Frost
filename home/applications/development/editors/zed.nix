{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.editors.zed;
in {
  options.frost.home.apps.development.editors.zed.enable = lib.mkEnableOption "Zed editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zed-editor-fhs
    ];
  };
}
