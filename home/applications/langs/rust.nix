{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.langs.rust;
in {
  options.frost.home.apps.langs.rust.enable = lib.mkEnableOption "Rust language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rust-analyzer # Brain
      pkgs.rustfmt # Janitor
    ];
  };
}
