{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.security.onepassword;

  # Base list of custom allowed browsers plus any toggle-based entries
  allAllowedBrowsers =
    cfg.allowedBrowsers
    ++ lib.optionals cfg.enableZenIntegration [
      "zen"
      "zen-bin"
      "zen-browser"
      "zen-beta"
      "zen-twilight"
    ];

  hasCustomBrowsers = allAllowedBrowsers != [];
in {
  options.frost.security.onepassword = {
    enable = lib.mkEnableOption "1Password";

    polkitOwners = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users authorized to use 1Password polkit integration.";
    };

    enableZenIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow Zen browser binaries to integrate with 1Password.";
    };

    allowedBrowsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["floorp" "vivaldi-bin"];
      description = "Additional custom browser binaries to whitelist in 1Password.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;

    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = cfg.polkitOwners;
    };

    # Only create the file if custom browsers are specified or enabled
    environment.etc = lib.mkIf hasCustomBrowsers {
      "1password/custom_allowed_browsers" = {
        text = lib.concatStringsSep "\n" (lib.unique allAllowedBrowsers) + "\n";
        mode = "0644";
      };
    };
  };
}
