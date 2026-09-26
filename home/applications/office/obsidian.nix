{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.office.obsidian;
in {
  imports = [inputs.obsidian.homeManagerModules.default];

  options.frost.home.apps.office.obsidian = {
    enable = lib.mkEnableOption "Obsidian notes tool";
  };

  config = lib.mkIf cfg.enable {
    programs.obsidian = {
      enable = true;

      cli.enable = true;

      # Global defaults for all vaults (optional)
      defaultSettings = {
        appearance.baseTheme = "dark";
      };

      # Declare your vaults
      vaults = {
        # The key is your vault identifier/path
        "Workspace/Notes" = {
          enable = true;
          # Optional: vault-specific additions or overrides
          # settings = { ... };
        };
      };
    };
  };
}
