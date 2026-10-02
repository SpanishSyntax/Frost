{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.office.obsidian;
in {
  options.frost.home.apps.office.obsidian = {
    enable = lib.mkEnableOption "Obsidian notes tool";

    baseTheme = lib.mkOption {
      type = lib.types.enum ["dark" "light" "system"];
      default = "dark";
      description = "Default appearance base theme for all vaults.";
    };

    vaults = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable managing this vault.";
            };

            path = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Path to the vault directory relative to $HOME.
                Defaults to the attribute name if not specified.
              '';
            };

            # You can add extra vault-specific settings here
            settings = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = {};
              description = "Extra vault configuration overrides.";
            };
          };
        }
      );
      default = {};
      example = {
        notes = {
          path = "Workspace/Notes";
        };
      };
      description = "Declared Obsidian vaults.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.obsidian = {
      enable = true;
      cli.enable = true;

      defaultSettings = {
        appearance.baseTheme = cfg.baseTheme;
      };

      # Map your custom frost vaults into programs.obsidian.vaults
      vaults = lib.pipe cfg.vaults [
        # Filter out disabled vaults
        (lib.filterAttrs (_: v: v.enable))
        # Map each entry to the path expected by programs.obsidian
        (lib.mapAttrs' (name: v: let
          vaultPath =
            if v.path != null
            then v.path
            else name;
        in
          lib.nameValuePair vaultPath {
            # Pass any vault-specific settings down to the module
            settings = v.settings;
          }))
      ];
    };
  };
}
