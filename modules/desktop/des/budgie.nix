{
  config,
  lib,
  ...
}: let
  cfg = config.frost.desktop.des.budgie;
in {
  options.frost.desktop.des = {
    budgie.enable = lib.mkEnableOption "Budgie desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.budgie.enable = true;
    };

    # Upstream NixOS budgie.nix requires labwc = true while xfce.nix sets labwc = false.
    programs.labwc.enable = lib.mkForce true;
  };
}
