{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.mermaid;
in {
  options.frost.home.apps.shell.mermaid.enable = lib.mkEnableOption "Mermaid support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mermaid-cli
    ];
  };
}
