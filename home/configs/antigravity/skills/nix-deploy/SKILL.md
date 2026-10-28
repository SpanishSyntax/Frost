---
name: nix-deploy
description: >-
  Dedicated infrastructure assistant for maintaining, generating, and deploying
  reproducible NixOS and Home Manager configurations tailored strictly to the
  Frost architecture. Use this skill when the user asks to modify, create, or
  debug Nix modules, Frost Iceberg configurations, Home Manager dotfiles, or
  system services.
---

# Nix Deploy

## Summary
A specialized infrastructure assistant for maintaining, developing, and deploying reproducible NixOS and Home Manager configurations explicitly tailored to the user's custom **Frost** architecture. Operates agentically by inspecting the Frost codebase (`~/Frost`), generating conforming modules, ensuring out-of-store symlink compliance, and validating changes with Sled MCP and Nix tools.

## When to Use
- The user asks to configure, add, or debug Nix, NixOS, or Home Manager modules in `~/Frost`.
- The user is managing user applications, dotfiles, desktop tools (e.g., Neovim, Hyprland, Sioyek, Calibre), or systemd services.
- The user is integrating or updating **Frost Icebergs** (`barograph`, `basecamp`, `beacon`, `borealis`, `goggles`, `prism`, `rime`, `searchlight`, `shards`, `sled`, `snowpack`).
- The user asks to validate flakes, inspect system generations, or deploy host updates.

## Frost Architecture Conventions (CRITICAL)

When generating or editing Nix code in Frost:

### 1. Flake & Fleet Separation
- `flake.nix` is the central source of truth for inputs, overlays, system definitions, and module exports.
- Fleet configurations in `hosts/<host>/` (e.g., `workstation`, `server`) enable or toggle options via declarative flags; **never write monolithic inline configurations at the host level**.

### 2. Strict Directory Hierarchy
- **System Modules**: Placed in `modules/system/` or `modules/hardware/`.
- **User Applications**: Placed in `home/applications/<category>/<tool>.nix` (e.g., `home/applications/development/nvim.nix`, `home/applications/reading/calibre.nix`).
- **Frost Icebergs**: Placed in `home/applications/icebergs/<app>.nix` for first-class ecosystem utilities.
- **User Services**: Placed in `home/services/<service>.nix`.
- **Live Dotfiles & Configs**: Placed in `home/configs/<app>/`.

### 3. Out-of-Store Symlinking Pattern
All user modules managing configuration files must support out-of-store symlinking (`mkOutOfStoreSymlink`) to allow live editing without requiring a full rebuild on every dotfile tweak:
```nix
options.frost.home.apps.<category>.<app> = {
  enable = lib.mkEnableOption "<app description>";

  configsPath = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = config.frost.home.environment.configsPath;
    example = null;
    description = ''
      Path to configs for out-of-store symlinking (`mkOutOfStoreSymlink`).
      Defaults to global `frost.home.environment.configsPath` (`~/Frost/home/configs`).
      Set to `null` to use the pure flake store.
    '';
  };
};
```
And wire the file source conditionally:
```nix
xdg.configFile."<app>/<config_file>" = lib.mkIf cfg.enable {
  source =
    if cfg.configsPath != null
    then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/<app>/<config_file>"
    else "${inputs.self}/home/configs/<app>/<config_file>";
};
```

### 4. Syncthing & State Awareness
For applications storing state, databases, or documents (e.g., Calibre libraries, Obsidian vaults, Zotero data), adhere to Syncthing sync definitions and ignore patterns configured in `home/services/syncthing.nix` and `home/environment/ignores.nix`.

## Agentic Operational Procedures

1. **Codebase Inspection**:
   - Inspect existing modules in `~/Frost` to replicate exact idioms, options schemas, and naming conventions.
   - Use Sled MCP tools (`sled/find`, `sled/cat`, `sled/ls`) to navigate `~/Frost`.

2. **Generate the Module**:
   - Write clean, formatted Nix code exposing options under the `frost.home...` or `frost.system...` namespace.
   - Set sensible defaults and import necessary upstream flake inputs where required.

3. **Validation & Verification**:
   - Run `nix flake check` or invoke Sled MCP's `sled/nix_flake_check` on `~/Frost` to verify syntax and dependency resolution.
   - Inspect flake metadata with `sled/nix_flake_show` or `sled/nix_flake_metadata` if updating inputs.

4. **Fleet Enablement**:
   - Specify the exact toggle line needed in the host profile (e.g., `frost.home.apps.<category>.<app>.enable = true;`).
