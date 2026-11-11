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

## Dotfiles Hot-Reloading

Frost allows you to modify application dotfiles without running `nixos-rebuild switch`.

### Configuration

In your Home Manager configuration:

```nix
frost.home = {
  dotfiles = {
    enableSymlinks = true;
    symlinkSourcePath = "/home/youruser/Frost/configs/home";
  };
};
```

### Workflow

1. Navigate to `configs/home/`:
   ```bash
   cd ~/Frost/configs/home
   ```
2. Modify keybindings or themes (e.g. in `caelestia/shell.json` or `kitty/kitty.conf`).
3. Reload the application directly or reload your Wayland compositor (`hyprctl reload`).
4. Changes appear immediately because files are linked out-of-store directly to your repository clone.

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
frost.security.sops_nix = {
  enable = true;
  defaultSopsFile = ./secrets/passwords.yaml;
};

frost.services.syncthing = {
  enable = true;
  sopsFile = ./secrets/syncthing.yaml;
};
```
