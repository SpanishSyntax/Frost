# frost/services/eduvpn.nix (NixOS system module)
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.services.eduvpn;
in {
  options.frost.services.eduvpn = {
    enable = lib.mkEnableOption "eduVPN system integration";
  };

  config = lib.mkIf cfg.enable {
    # NixOS built-in module handles systemd services, polkit, and wg plumbing
    programs.eduvpn.enable = true;

    # Dynamic firewall interface trust
    networking.firewall.trustedInterfaces = [
      "wg+"
      "wg-eduvpn+"
      "tun+"
    ];
  };
}
