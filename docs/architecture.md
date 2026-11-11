# Architecture & Foundations

Frost implements a modular architecture designed to decouple system and user environment definitions from hardware bindings and identity credentials.

---

## Why "Frost"? (The Lore)

> **frost** (`/frɔːst/`) — *noun:* The crystalline deposit of delicate ice needles that binds cold surfaces together, transforming raw terrain into a unified, resilient winter landscape.

In polar extremes, frost is not inert freezing—it is the crystalline glaze that seals porous stone, locks shifting gravel into permanent bedrock, and coats entire mountain ranges in a cohesive protective armor.

**Frost serves as the foundational glaze of the ecosystem:**
- **Bedrock Glaze**: A declarative, hermetic NixOS foundation that binds system services, desktop environments, and developer toolchains into a resilient whole.
- **Granular Crystallization**: Over 110 toggleable modules that crystallize only when enabled, leaving zero unneeded weight or runtime bloat behind.

---

## Flake & Fleet Separation

A core principle in Frost is separating reusable framework logic from fleet deployments:

```mermaid
graph TD
    subgraph Frost["Frost Framework (SpanishSyntax/Frost)"]
        Modules["modules/ (frost.* system modules)"]
        HomeApps["home/applications/ (110+ app modules)"]
        LibHelpers["lib/helpers (mkSystem, mkHome)"]
        BaseHosts["hosts/ (base.nix, boot.nix)"]
    end

    subgraph Fleet["Private Fleet Repository"]
        Flake["flake.nix"]
        PrivateHosts["hosts/<machine>/configuration.nix"]
        PrivateDisko["hosts/<machine>/disko.nix"]
        PrivateSecrets["secrets/ (sops-nix encrypted files)"]
    end

    Flake -->|inputs.frost| Frost
    PrivateHosts -->|enables| Modules
    PrivateHosts -->|configures| HomeApps
    Flake -->|instantiates| LibHelpers
```

1. **Upstream (Frost)**: Contains parameter-driven modules, application wrappers, out-of-store symlink logic, and base NixOS defaults.
2. **Downstream (Fleet)**: Contains hardware configurations, disk partitioning targets, user definitions, and SOPS-encrypted credentials.

---

## Directory Hierarchy

The repository is structured into distinct, non-overlapping domains:

```text
Frost/
├── flake.nix               # Flake inputs, library exports, and starter configurations
├── installer/              # Deployment & rescue tooling (frost-install, frost-recover)
│   ├── default.nix         # Derivations for installer tools
│   ├── install.sh          # Automated Disko partitioning & deployment script
│   └── recover.sh          # Auto-mounting rescue tool for Btrfs impermanence
├── lib/
│   └── helpers/            # Reusable builders (mkSystem, mkHome, recursive file scraper)
├── hosts/                  # Starter host configurations and base profiles
│   ├── base.nix            # Core Nix settings (GC, flakes, trusted-users)
│   ├── boot.nix            # standard systemd-boot loader configuration
│   ├── workstation/        # Starter graphical workstation profile
│   └── server/             # Starter headless server profile
├── modules/                # System-level modules (frost.* namespace)
│   ├── desktop/            # Window managers, desktop environments, display managers
│   ├── hardware/           # PipeWire audio, Bluetooth, Networking, Power
│   ├── oci/                # OCI containerized services (Jellyfin, Immich, pgAdmin)
│   ├── security/           # Polkit, PAM (U2F), SOPS-nix, 1Password
│   ├── services/           # Tailscale, SSH, Cloudflared, Syncthing, AdGuard
│   ├── storage/            # Disko, Btrfs rollback, Impermanence, ZFS
│   └── virtualization/     # MicroVM, Docker, Podman, Libvirt, Bottles
└── home/                   # User-level Home Manager modules (frost.home.* namespace)
    ├── home.nix            # Central user module collector
    ├── applications/       # 110+ granular app modules (dev, creative, shell, office)
    ├── environment/        # Shell environment, fonts, GTK, XDG settings
    └── users/              # User profiles
        └── frost.nix       # Generic starter user environment
```

---

## Ephemeral Storage & Disko Partitioning

Frost treats root filesystems as ephemeral state. By leveraging [Disko](https://github.com/nix-community/disko) and Btrfs snapshots (or tmpfs-on-root via Impermanence), the root subvolume is wiped on every boot:

```mermaid
graph TD
    Root["/ (tmpfs or blank Btrfs subvolume)"] -->|Ephemeral| Discard["Wiped on boot"]
    Persist["/persist (Permanent Btrfs subvolume)"] -->|Bind-mount| State["SSH keys, Machine ID, SOPS keys"]
    NixStore["/nix (Permanent Btrfs subvolume)"] -->|Read-only| Store["Deterministic Nix Store"]
    Home["/home (Permanent Btrfs subvolume)"] -->|User Data| Data["User documents, downloads, git repos"]
```

### Subvolume Layout

In `hosts/workstation/disko.nix`, the storage layout is partitioned into:

- `@` — Ephemeral root, snapshotted or reset on boot.
- `@nix` — Persistent Nix store.
- `@persist` — Critical system state (`/etc/machine-id`, `/etc/ssh`, `/etc/sops`).
- `@home` — Persistent user home directories.
- `@boot` — ESP partition for systemd-boot.

---

## Out-of-Store Symlinking

Iterating on Wayland configurations or desktop dotfiles traditionally requires a `nixos-rebuild switch`. Frost provides parameterized out-of-store symlinking:

```nix
frost.home = {
  dotfiles = {
    enableSymlinks = true;
    symlinkSourcePath = "/home/youruser/Frost/configs/home";
  };
};
```

When `enableSymlinks` is active, Home Manager generates symlinks using `config.lib.file.mkOutOfStoreSymlink` pointing directly into your local checkout. File modifications take effect instantly on save without invoking `nixos-rebuild`.
