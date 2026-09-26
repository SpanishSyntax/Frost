{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.security.onepassword;
in {
  options.frost.security.onepassword = {
    enable = lib.mkEnableOption "1Password";
    polkitOwners = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users authorized to use 1Password polkit integration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs._1password-cli
      pkgs._1password-gui
    ];
    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          zen
          zen-browser
          zen-beta
          zen-twilight
        '';
        mode = "0755";
      };
    };
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = cfg.polkitOwners;
    };
  };
}
