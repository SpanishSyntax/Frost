{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.obsidian;
in {

  options.frost.home.apps.office.obsidian = {
    enable = lib.mkEnableOption "Obsidian notes tool";
  };

  config = lib.mkIf cfg.enable {
    programs.obsidian = {
      enable = true;

      cli.enable = true;

      # Global defaults for all vaults
      defaultSettings = {
        appearance.baseTheme = "dark";
      };

      # Vault-specific additions or overrides
      vaults = {
        "Workspace/Notes" = {
          enable = true;
        };
      };
    };
  };
}
