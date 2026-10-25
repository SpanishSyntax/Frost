# Antigravity Global Environment Rules

## 1. Tooling Priority: Sled MCP Preference
When inspecting the filesystem, git repositories, docker containers, systemd units, or Nix configuration:
- **DO NOT** use `run_command` for standard unix/git/inspection commands (`ls`, `cat`, `head`, `tail`, `tree`, `find`, `grep`, `stat`, `git status`, `git diff`, `git log`, `docker ps`, `systemctl status`, etc.).
- **ALWAYS** call the `sled` MCP server using `call_mcp_tool`.
  - **`sled/ls`**: `{"path": ".", "all_files": false, "long": false}` (filters out `.git`, `node_modules`, `result`, `.direnv`, `__pycache__`, etc.)
  - **`sled/tree`**: `{"path": ".", "max_depth": 3}`
  - **`sled/cat`**: `{"path": "...", "max_lines": 200}`
  - **`sled/head`** / **`sled/tail`**: `{"path": "...", "lines": 50}`
  - **`sled/grep`**: `{"path": "...", "pattern": "..."}`
  - **`sled/find`**: `{"path": "...", "name": "*pattern*"}`
  - **`sled/git_status`**, **`sled/git_diff`**, **`sled/git_log`**
  - **`sled/nix_flake_check`**, **`sled/nix_flake_show`**, **`sled/nixos_generations`**
  - **`sled/docker_ps`**, **`sled/docker_logs`**
  - **`sled/systemctl_status`**, **`sled/journalctl`**
- Reserve `run_command` strictly for commands without atomic MCP equivalents (e.g. running builds, test suites, or execution scripts).

## 2. Frost Architecture Conventions
When generating or modifying Nix code in Frost:
- **Flake & Fleet Separation**: `flake.nix` is the central source of truth. Fleet configurations in `hosts/` enable or toggle options; do not write monolithic inline configs.
- **Directory Hierarchy**:
  - System modules: `modules/`
  - User applications: `home/applications/<category>/<tool>.nix`
  - User services: `home/services/<service>.nix`
  - Static/live dotfile configs: `home/configs/<app>/`
- **Out-of-Store Symlinking**:
  Follow Frost's standard `configsPath` pattern:
  ```nix
  configsPath = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = config.frost.home.environment.configsPath;
    description = "Path to configs for out-of-store symlinking. Set null for pure flake store.";
  };
  ```
  And conditionally link:
  ```nix
  source =
    if cfg.configsPath != null
    then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/<app>/..."
    else "${inputs.self}/home/configs/<app>/...";
  ```
- **State & Syncthing Awareness**: Respect Syncthing sync rules and ignore patterns defined in `home/services/syncthing.nix` and `home/environment/ignores.nix`.

## 3. Communication Style
- Keep responses concise and mathematically/technically precise.
- Format all file references and symbols as clickable markdown links (`file:///absolute/path#L1-L10`).
- Favor interactive Antigravity Artifacts (with Mermaid diagrams or math) for complex architectures or tradeoff comparisons.
