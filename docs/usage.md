# Operations & CLI Reference

This document covers operational recipes, maintenance tasks, and CLI workflows for Frost systems.

---

## frost-install

`frost-install` is an automated partitioning and deployment script designed to execute from a live NixOS installer environment.

### Usage

```bash
sudo nix run github:SpanishSyntax/Frost#install -- <host> [flake-uri]
```

### Execution Pipeline

1. **Safety Confirmation**: Verifies target host and confirms destructive drive repartitioning.
2. **Disko Execution**: Runs `disko --mode disko` against the selected host configuration, partitioning the drive and formatting Btrfs/ext4/swap filesystems.
3. **Persist Setup**: Creates required persistence directories:
   - `/mnt/persist/etc/ssh`
   - `/mnt/persist/etc/sops`
   - `/mnt/persist/etc/secrets/initrd`
4. **Host Identity & Keys**:
   - Copies existing installer SSH keys or generates a fresh ed25519 host key.
   - Generates a Dropbear ed25519 key for early remote LUKS unlocking.
   - Initializes SOPS age identity file (`/mnt/persist/etc/sops/identities.txt`).
   - Prints the host's age public key derived via `ssh-to-age`.
5. **NixOS Install**: Invokes `nixos-install --flake "<flake-uri>#<host>" --no-root-passwd`.

> [!WARNING]
> Running `frost-install` reformats the target drives defined in the host's `disko.nix`. Ensure device identifiers (`/dev/nvme0n1`, `/dev/sda`) match your target machine before running.

---

## frost-recover

`frost-recover` is an emergency rescue tool for recovering systems with Btrfs impermanence and LUKS encryption.

### Usage

```bash
# Run rescue tool from a live installer environment
sudo nix run github:SpanishSyntax/Frost#recover
```

### Recovery Actions

- **LUKS Discovery**: Automatically discovers encrypted LUKS partitions on `/dev/nvme*` or `/dev/sd*` and prompts for passphrase unlock.
- **Btrfs Subvolume Mounting**: Mounts subvolumes in correct hierarchy to `/mnt`:
  - `@` $\rightarrow$ `/mnt`
  - `@nix` $\rightarrow$ `/mnt/nix`
  - `@persist` $\rightarrow$ `/mnt/persist`
  - `@home` $\rightarrow$ `/mnt/home`
  - ESP boot partition $\rightarrow$ `/mnt/boot`
- **Chroot Access**: Once mounted, enter the system environment via:
  ```bash
  sudo nixos-enter
  ```

---

## Everyday Rebuild Workflows

### Testing Configurations

Test a configuration build without updating the systemd-boot bootloader menu:

```bash
nixos-rebuild test --flake .#workstation
```

### Switching Generations

Permanently switch to a new generation:

```bash
sudo nixos-rebuild switch --flake .#workstation
```

### Upgrading Flake Inputs

Lockfile inputs can be updated across the fleet:

```bash
# Update all flake inputs
nix flake update

# Update a single input
nix flake lock --update-input nixpkgs
```

---

## Dotfiles Hot-Reloading & Tapes v2

Frost supports two complementary dotfile layers: **out-of-store symlinks** for core/developer configs and **Tapes v2** for hot-swappable desktop rices.

### Out-of-Store Configuration (`configsPath`)

In your Home Manager configuration:

```nix
frost.home.environment = {
  # Mutable out-of-store symlinks (live hot-reload)
  configsPath = "${config.home.homeDirectory}/Fleet/configs/home";

  # Link extra WM/app config directories from configsPath into ~/.config/<name>
  extraConfigs = ["hypr" "mango" "niri"];

  # Or pure in-store build (ideal for headless servers)
  # configsPath = ../configs/home;
  # mutable = false;
};
```

1. Edit any tracked config inside `configs/home/` (e.g. `caelestia/shell.json`, `hypr/hyprland.lua`, `sled/sled.toml`, `zsh.d/custom.zsh`).
2. Reload the application or compositor (`hyprctl reload`).
3. Changes apply immediately without running `nixos-rebuild switch`.

### Pulling & Swapping Rices with Tapes v2

Frost ships starter templates in `configs/home/`, and you can declaratively materialize or pull additional community rices using **Tapes v2** (`frost.home.apps.settings.desktop.tapes`):

```nix
frost.home.apps.settings.desktop.tapes = {
  enable = true;
  gui.enable = true; # Tapes-Deck GUI
  featured = ["caelestia" "end-4" "nebula" "noctalia-libre" "serpantinum"];
};
```

```bash
# Install an official curated tape (from futurekismo-oss/featured-tapes)
tapes install-featured caelestia

# Or pull any public dotfile repository as a tape
tapes install https://github.com/some_user/cyberpunk --name cyberpunk

# Preview targets and insert/eject hooks before applying
tapes show cyberpunk

# Atomically swap ONLY the tape's targets into ~/.config (via renameat2)
tapes insert cyberpunk

# Restore your exact base ~/.config in one command
tapes eject
```

> [!IMPORTANT]
> **Home Manager + Tapes Safety**:
> - Tapes swaps only the targets present in a tape (leaving `sled/`, `nvim/`, `zsh.d/`, `uwsm/`, and browser profiles intact).
> - If you want Tapes to exclusively manage your desktop rice (`caelestia/`, `hypr/`), set `frost.home.desktop.shells.igloo.manageConfig = false` and omit `"hypr"` from `frost.home.environment.extraConfigs`.
> - Always run `tapes eject` before `nixos-rebuild switch` if an inserted tape overrides any Home Manager-managed target.

---

## SOPS Secrets Workflow

Frost integrates with [SOPS-nix](https://github.com/Mic92/sops-nix) for declarative credential management.

### Deriving Host Age Key

During `frost-install`, your host age public key is printed. You can also derive it manually from your host's ed25519 SSH key:

```bash
ssh-to-age < /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
```

### Encrypting Secrets

Add the public age key to your `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Create or edit an encrypted file:

```bash
sops secrets/passwords.yaml
```

### Consuming Secrets in Modules

Declare the file path in your host configuration:

```nix
frost.security.secrets.sops_nix = {
  enable = true;
  defaultSopsFile = ./secrets/passwords.yaml;
};

frost.network.sync.syncthing = {
  enable = true;
  sopsFile = ./secrets/syncthing.yaml;
};
```
