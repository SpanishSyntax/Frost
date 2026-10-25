---
name: nix-deploy
description: Dedicated infrastructure assistant for maintaining and deploying reproducible NixOS and Home Manager setups tailored to the custom Frost architecture.
---

# Nix Deploy

## Summary
A dedicated infrastructure assistant for maintaining reproducible NixOS and Home Manager setups explicitly tailored to the user's custom "Frost" architecture. Operates agentically by inspecting the Frost codebase, generating conforming modules, and running flake validation.

## When to Use
- User mentions Nix, NixOS, Home Manager, or flake configurations.
- User is configuring tools (e.g., Neovim, Sioyek, Syncthing, Calibre, Hyprland) or system services.
- User references Frost or Glacier deployments.

## The Frost Architecture Constraints (CRITICAL)
When generating or modifying Nix code in Frost:

1. **Flake & Fleet Separation**: `flake.nix` is the central source of truth. The fleet (e.g., `hosts/workstation`, `hosts/server`) enables or toggles modules; never write monolithic inline configs at the host level.
2. **Directory Structure Strictness**:
   - System-level modules go in `modules/`.
   - User-level (Home Manager) applications go in `home/applications/<category>/<tool>.nix` (e.g., `home/applications/development/nvim.nix`, `home/applications/reading/calibre.nix`).
   - User-level services go in `home/services/<service>.nix`.
   - Raw dotfiles and configs go in `home/configs/<app>/`.
3. **Out-of-Store Symlinking Pattern**:
   Always expose the configurable `configsPath` option:
   ```nix
   configsPath = lib.mkOption {
     type = lib.types.nullOr lib.types.str;
     default = config.frost.home.environment.configsPath;
     example = null;
     description = ''
       Path to configs for out-of-store symlinking (`mkOutOfStoreSymlink`).
       Defaults to global `frost.home.environment.configsPath`.
       Set to `null` to use the pure flake store.
     '';
   };
   ```
   And implement the conditional:
   ```nix
   source =
     if cfg.configsPath != null
     then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/<app>/<file>"
     else "${inputs.self}/home/configs/<app>/<file>";
   ```
4. **Syncthing Awareness**: If configuring applications that store state or libraries (like Calibre, Zotero, or Obsidian), ensure paths align with Syncthing sync rules defined in `home/services/syncthing.nix` and `home/environment/ignores.nix`.

## Agentic Steps
1. **Locate Target Path**: Identify where the file belongs in Frost. Check existing sibling modules to match idioms.
2. **Generate the Module**: Write declarative Nix code matching the standard Frost option schema (`frost.home.apps.<category>.<tool>`).
3. **Flake Check**: Use `sled/nix_flake_check` (or `nix flake check`) to ensure no syntax or evaluation errors.
4. **Fleet Enablement**: Provide the exact toggle line needed in the host configuration (e.g. `hosts/workstation/home-manager.nix`).
