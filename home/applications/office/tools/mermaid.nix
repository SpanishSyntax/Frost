{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.mermaid;
in {
  options.frost.home.apps.office.tools.mermaid.enable = lib.mkEnableOption "Mermaid support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mermaid-cli
    ];
  };
}
