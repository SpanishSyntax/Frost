{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.networking.nmap;
in {
  options.frost.home.apps.networking.nmap.enable = lib.mkEnableOption "Nmap, RustScan, Zmap, MassScan";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nmap
      pkgs.rustscan
      pkgs.zmap
      pkgs.masscan
    ];
  };
}
