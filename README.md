<img src="assets/banner.png" alt="Delicate frost needle crystals coating moorland heather beneath a winter dawn sky" width="100%" />

# Frost ❄️

> Modular, Declarative NixOS Starter Framework & Flake Distribution

Frost is an opinionated, modular NixOS framework and starter distribution. It separates reusable system and desktop infrastructure from personal fleet configurations, providing **110+ granular, toggleable modules** across system services, modern Wayland desktops, development toolchains, and user environments.

> [!TIP]
> **Complete Documentation:** Comprehensive option listings, impermanence architecture, and operational recipes are available on the **[Frost Documentation Site](https://spanishsyntax.github.io/Frost)**.

---

## Core Tenets

- **Zero Burnt-in Identity**: Parameterized modules with no hardcoded credentials, personal paths, or machine identities.
- **Dual Consumption Model**: Use as a standalone starter template (fork and clone) or consume as an external Flake library in a private fleet repository.
- **Declarative Storage**: Integrated Disko partitioning with root-on-tmpfs and Btrfs ephemeral impermanence support.
- **Rapid Iteration**: Live dotfile hot-reloading via parameterized out-of-store symlinks without full system rebuild cycles.
- **Automated Lifecycle**: Declarative installation and rescue tools (`frost-install` and `frost-recover`).

---

## Why "Frost"?

> **frost** (`/frɔːst/`) — *noun:* The crystalline deposit of delicate ice needles that binds cold surfaces together, transforming raw terrain into a unified, resilient winter landscape.

In polar extremes, frost is not inert freezing—it is the crystalline glaze that seals porous stone, locks shifting gravel into permanent bedrock, and coats entire mountain ranges in a cohesive protective armor.

**Frost serves as the foundational glaze of the ecosystem:**
- **Bedrock Glaze**: A declarative, hermetic NixOS foundation that binds system services, desktop environments, and developer toolchains into a resilient whole.
- **Granular Crystallization**: Over 110 toggleable modules that crystallize only when enabled, leaving zero unneeded weight or runtime bloat behind.

---

## Repository Layout

```text
Frost/
├── flake.nix               # Flake inputs, library exports, and starter configurations
├── installer/              # Automated installation & rescue tools (frost-install, frost-recover)
│   ├── install.sh
│   └── recover.sh
├── lib/                    # Helpers (mkSystem generator, recursive file scraper)
│   └── helpers/
├── hosts/                  # Host profiles & archetypes
│   ├── base.nix            # Core Nix settings (GC, flakes, trusted-users)
│   ├── boot.nix            # Standard systemd-boot loader configuration
│   ├── workstation/        # Starter graphical workstation (Hyprland + GNOME)
│   └── server/             # Starter headless server (Docker + SSH)
├── modules/                # System-level 2-level modules (frost.* namespace)
│   ├── system/             # Boot (console, custom Plymouth builder), locale, runtime, storage
│   ├── hardware/           # Audio (PipeWire), peripherals, power, sensors (IIO, wluma ALS)
│   ├── network/            # Stack (firewall, networking), edge, remote, sync, VPNs
│   ├── security/           # Auth (PAM, Polkit, YubiKey) & secrets (SOPS, 1Password, keyring)
│   ├── desktop/            # 7 DMs, 8 DEs, 9 WMs, and session-scoped XDG portals
│   ├── virtualization/     # Containers (Docker, Podman, OCI), VMs (MicroVM, Libvirt), stacks
│   └── programs/           # Flatpak, gaming (Steam), system utilities
├── configs/                # Starter dotfiles & system configs (out-of-store or in-store)
│   ├── home/               # Starter user configs (caelestia, nvim, sled, zsh.d, antigravity)
│   └── system/             # Starter system configs (caddy)
└── home/                   # User-level Home Manager modules (frost.home.* namespace)
    ├── home.nix            # Central user module collector
    ├── applications/       # 110+ XDG-categorized app modules (ai, dev, gaming, graphics, ...)
    ├── desktop/            # Wayland shells (caelestia) & desktop tools (borealis, shards, caelestia_cli)
    ├── environment/        # configsPath / extraConfigs / mkSource, fonts, GTK, XDG, ignores
    ├── services/           # User services (syncthing, google_drive)
    └── users/              # User profiles
        └── frost.nix       # Generic starter user environment
```

---

## Getting Started

### Option A: Starter Template (Fork & Clone)

Ideal for configuring a single workstation or server directly in one repository:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/SpanishSyntax/Frost.git ~/Frost
   cd ~/Frost
   ```

2. **Adjust starter configurations**:
   - `hosts/workstation/` — Pre-configured with Hyprland, GNOME, PipeWire, SDDM, and Disko NVMe partitioning.
   - `hosts/server/` — Pre-configured headless setup with Docker, OpenSSH, and standard Disko SATA partitioning.
   - `home/users/frost.nix` — Starter user dotfiles (Zsh, Starship, Neovim, Kitty, Git).

3. **Customize credentials**:
   In `hosts/workstation/users.nix`, adjust user settings and authorized SSH keys:
   ```nix
   users.users.frost = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
     initialPassword = "your-password-here";
     # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
   };
   ```

4. **Build and switch**:
   ```bash
   # Test without updating bootloader
   nixos-rebuild test --flake .#workstation

   # Switch permanently
   sudo nixos-rebuild switch --flake .#workstation
   ```

---

### Option B: External Flake Library (Private Fleet Architecture)

Ideal if you maintain a private fleet repository containing host identities, disk mappings, and encrypted SOPS secrets:

1. **Define `flake.nix` in your private repository**:
   ```nix
   {
     description = "Personal Fleet Configuration";

     inputs = {
       frost.url = "github:SpanishSyntax/Frost";
       nixpkgs.follows = "frost/nixpkgs";
     };

     outputs = { self, frost, nixpkgs, ... } @ inputs: let
       inherit (frost.lib) mkSystem;
     in {
       nixosConfigurations = {
         my-workstation = mkSystem {
           host = "my-workstation";
           modules = [
             ./hosts/my-workstation/configuration.nix
           ];
           specialArgs = { inherit self; };
         };
       };
     };
   }
   ```

2. **Configure your host**:
   All `frost.*` options are pre-injected by `mkSystem`:
   ```nix
   { pkgs, ... }: {
     imports = [
       ./hardware-configuration.nix
       ./disko.nix
       ./users.nix
     ];

     frost = {
       desktop.wms.hyprland.enable = true;
       hardware.audio.pipewire.enable = true;
       hardware.peripherals.bluetooth.enable = true;
       security.auth.polkit.enable = true;
       system.runtime.home_manager.enable = true;
     };
   }
   ```

---

## Declarative Installation & Recovery

Frost packages deployment and rescue utilities available as Flake apps:

### 1. frost-install — Automated Partitioning & Deployment

Executes Disko to partition and format drives, prepares persistent directory structures (`/persist`), sets up host SSH keys, and installs NixOS:

```bash
# Direct execution from live installer:
sudo nix run github:SpanishSyntax/Frost#install -- workstation

# From a local clone:
sudo nix run .#install -- workstation
```

> [!CAUTION]
> **Destructive Disk Wipe & Liability Disclaimer**
> - **Full-Disk Repartitioning**: `frost-install` invokes Disko to repartition and format the target drives declared in your host's `disko.nix`, **permanently destroying all existing partitions and data** on those devices.
> - **No Liability for Data Loss**: This tool is provided strictly **"as is"** without warranty of any kind. The author and contributors assume **no responsibility or liability whatsoever for any data loss, filesystem corruption, unbootable systems, or hardware damage** resulting from the use or misuse of `frost-install` or `frost-recover`.
> - **Mandatory Backups & Full-Reset Readiness**: Before running `frost-install`, you are solely responsible for creating and verifying external backups of all important data, double-checking target device identifiers (`/dev/nvme0n1`, `/dev/sda`, etc.), and ensuring the target system is **100% ready for a complete destructive reset**.

### 2. frost-recover — Dynamic Rescue Mounting

Detects Btrfs root partitions (including LUKS-encrypted roots), discovers subvolumes (`@`, `@nix`, `@persist`, `@home`, `@boot`), and mounts them cleanly to `/mnt`:

```bash
# Auto-detects and mounts root filesystem to /mnt
sudo nix run github:SpanishSyntax/Frost#recover

# Enter the system chroot
sudo nixos-enter
```

---

## Option Namespaces

### System Options (`frost.*`)

All system modules follow a strict 2-level hierarchy (`frost.<domain>.<category>.<module>`):

| Namespace | Categories & Modules | Description |
| :--- | :--- | :--- |
| `frost.system` | `boot` (`console`, `plymouth`), `locale` (`datetime`, `fonts`, `locales`), `runtime` (`environment`, `fhs`, `home_manager`), `storage` (`btrfs_rollback`, `impermanence`, `trash`, `zfs`) | Bootloader, custom video/GIF Plymouth splash builder, locale stack, FHS/Home Manager runtime, and Btrfs/ZFS impermanence |
| `frost.hardware` | `audio` (`pipewire`), `peripherals` (`bluetooth`, `printing`, `uinput`), `power`, `sensors` (`iio`, `wluma`) | Low-latency PipeWire audio, Bluetooth/CUPS peripherals, laptop power management, IIO sensors, and `wluma` ALS auto-brightness |
| `frost.network` | `stack` (`firewall`, `networking`), `edge` (`adguard`, `caddy`, `cloudflared`), `remote` (`kde_connect`, `ssh`, `wayvnc`), `sync` (`google_drive`, `syncthing`), `vpn` (`eduvpn`, `openvpn`, `tailscale`, `wireguard`) | Declarative firewall, NetworkManager/networkd (`waitOnline`), reverse proxies, SSH/WayVNC, sync daemons, and mesh VPNs |
| `frost.security` | `auth` (`pam`, `polkit`, `yubikey`), `secrets` (`gnome_keyring`, `onepassword`, `sops_nix`) | PAM U2F/FIDO2 authentication, Polkit, YubiKey smartcard rules, SOPS-nix secrets, and 1Password |
| `frost.desktop` | `dms` (`permafrost`, `greetd`, `sddm`, `gdm`, `ly`, `lightdm`, `cosmic_greeter`, `defaultSession`), `des` (`gnome`, `plasma`, `cosmic`, `xfce`, `cinnamon`, `mate`, `lxqt`, `budgie`), `wms` (`hyprland`, `niri`, `sway`, `river`, `mango`, `i3`, `bspwm`, `awesome`, `qtile`), `portals` (`xdg`, `fjord`) | Decoupled display managers, co-installable desktop environments, standalone window managers, and session-scoped XDG portals |
| `frost.virtualization` | `containers` (`docker`, `podman`, `oci`, `compose2nix`), `vms` (`libvirt`, `microvm`, `virtualbox`), `stacks` (`immich`, `jellyfin`, `pgadmin`) | Socket-activated Docker (`enableOnBoot`, `autoPrune`), Podman/OCI containers, KVM/MicroVMs, and self-hosted stacks |
| `frost.programs` | `flatpak` (`bottles`, `flatseal`, `museum`), `gaming` (`steam`), `utilities` (`gnome_disks`, `gnome_disk_usage`, `iamb`) | System-level Flatpak management, Steam gaming stack, and disk utilities |

### User Options (`frost.home.*`)

Over 110 modular application wrappers organized by XDG desktop categories under `frost.home.apps.*`, plus decoupled desktop shells and tools under `frost.home.desktop.*`:

| Category | Modules | Description |
| :--- | :--- | :--- |
| `apps.ai` | `antigravity`, `beacon`, `flox`, `n8n`, `opencode`, `sled` | AI coding agents, Sled atomic MCP server bridge, learning harness, and workflow automation |
| `apps.development` | `editors` (`nvim`, `vscode`, `zed`, `android_studio`), `tools` (`basecamp`, `git`, `heimdall`, `postman`, `prism`, `dbeaver`), `langs` (`bash`, `cpp`, `go`, `java`, `js`, `latex`, `lua`, `markdown`, `nginx`, `nix`, `python`, `rust`, `toml`, `typst`, `yaml`) | IDEs, DevShell scaffolding (`basecamp`), terminal UI (`prism`), and 15 language toolchains/LSPs |
| `apps.gaming` | `launchers` (`gamemode`, `heroic`, `waylandcraft`) | GameMode, Heroic Launcher, and native Wayland Minecraft Fabric stack (`prismlauncher` + `waylandcraft`) |
| `apps.graphics` | `raster` (`gimp`, `sly`), `vector` (`inkscape`), `cad` (`blender`, `model_viewer`), `viewers` (`gnome_image_viewer`, `gnome_image_editor`), `scanning` (`gnome_scanner`, `gnome_ocr`) | 2D/3D graphics authoring, CAD, OCR, and image viewers |
| `apps.media` | `audio` (`cozy`, `skald`, `spotify`, `pwvucontrol`, `gnome_radio`), `video` (`anime`, `netflix`, `obs`, `kdenlive`, `gnome_video_player`) | Audio/video production, Skald neural M4B audiobook compiler, OBS Studio, and media players |
| `apps.network` | `browsers` (`chrome`, `firefox`, `tor`, `zen`), `chat` (`discord`, `teams`, `telegram`, `tut`, `whatsapp`), `remote` (`dnsutils`, `eduvpn`, `iperf`, `kde_connect`, `mappers`, `openssl`, `remmina`), `transfer` (`aria2`, `gnome_torrents`, `parabolic`) | Web browsers, messaging clients, remote desktop/network diagnostics, and file transfer |
| `apps.office` | `docs` (`libreoffice`, `obsidian`, `marktext`, `rnote`), `readers` (`calibre`, `foliate`, `goggles`, `sioyek`, `zathura`, `zlibrary`), `tools` (`autofirma`, `ghostscript`, `mermaid`, `pandoc`, `searchlight`, `snowpack`, `stirling`, `zotero`) | Snowpack Typst/LaTeX compiler, Searchlight PDF search, Goggles GFM viewer, and document readers |
| `apps.science` | `diagrams` (`drawio`, `lantern`), `electronics` (`kicad`), `gis` (`qgis`), `math` (`barograph`, `octave`) | Lantern interactive simulation compiler, Barograph figure extractor, KiCad, and QGIS |
| `apps.settings` | `desktop` (`helm`, `nwg_look`, `tapes`), `packages` (`gnome_software`), `security` (`gnome_seahorse`, `onepassword`, `pass`, `sops`, `vulnix`) | Helm Hyprland studio, Tapes v2 (`tapes`, `tapes-deck`, `featured-tapes`), and secret managers |
| `apps.system` | `shell` (`bat`, `curl`, `eza`, `fastfetch`, `fzf`, `glow`, `jq`, `kitty`, `ripgrep`, `starship`, `tmux`, `zoxide`, `zsh`), `core` (`bluetooth`, `sqlite`, `usbutils`, `zip`), `desktop` (`thunar`, `gnome_characters`, `gnome_file_roller`), `virtualization` (`distrobox`, `docker`, `virt_manager`) | Terminal emulators, modern Unix CLI stack, file managers, and Distrobox/VM frontends |
| `apps.utility` | `accessories` (`calculator`, `rime`, `rss`, `gnome_calculator`) | Rime batch filename sanitizer, desktop calculators, and utilities |
| `desktop` | `shells` (`caelestia`), `tools` (`awww`, `borealis`, `caelestia_cli`, `shards`) | Decoupled Wayland desktop shell (`caelestia`), atmospheric wallpaper daemon (`borealis`), and clipboard overlay (`shards`) |
| `environment` | `configsPath`, `mutable`, `extraConfigs`, `mkSource`, `fonts`, `gtk`, `xdg`, `ignores` | Centralized dotfile source resolver (live out-of-store symlinks vs pure Nix store) |
| `services` | `google_drive`, `syncthing` | User-level Google Drive mount and Syncthing synchronization |

---

## Decoupled Desktop Architecture, Dotfiles, & Tapes v2

Frost cleanly separates five desktop layers so multiple Desktop Environments, Window Managers, and shells can coexist on the same host without conflict:

1. **Display Managers (`frost.desktop.dms.*`)**: `permafrost`, `greetd`, `sddm`, `gdm`, `ly`, `lightdm`, and `cosmic_greeter` are decoupled from any specific DE/WM and share unified `frost.desktop.dms.defaultSession` resolution.
2. **Desktop Environments (`frost.desktop.des.*`)**: 8 full DEs (`gnome`, `plasma`, `cosmic`, `xfce`, `cinnamon`, `mate`, `lxqt`, `budgie`) that can be co-installed alongside standalone WMs.
3. **Window Managers (`frost.desktop.wms.*`)**: 9 standalone WMs (`hyprland`, `niri`, `sway`, `river`, `mango`, `i3`, `bspwm`, `awesome`, `qtile`) with session-scoped Polkit agents (`ConditionEnvironment`) and IIO screen rotation (`hyprland` Lua/legacy + `iioTabletModeOnly`, `sway` `rot8`).
4. **Session-Scoped Portals (`frost.desktop.portals.*`)**: `xdg` generates per-compositor `<session>-portals.conf` files so custom portals like `fjord` apply only to registered WMs and never hijack full DEs like GNOME or Plasma.
5. **User Shells & Rices (`frost.home.desktop.*` & `tapes`)**: `caelestia` injectors target `~/.config/uwsm/env-<compositor>`, while user daemons (`borealis`, `shards`) respect `manageConfig` and `systemd.enable`.

### 1. Out-of-Store Dotfiles (`configsPath` & `extraConfigs`)

```nix
frost.home.environment = {
  # String path -> mutable out-of-store symlinks (live hot-reload)
  configsPath = "${config.home.homeDirectory}/Fleet/configs/home";

  # Link additional WM/app directories from configsPath into ~/.config/<name>
  extraConfigs = ["hypr" "mango" "niri"];

  # Or Nix path literal -> immutable in-store copy (ideal for servers)
  # configsPath = ../configs/home;
  # mutable = false;

  # Or omit / null -> Frost's built-in starter configs in configs/home/
};
```

Edits inside `configs/home/` take effect immediately on reload without triggering `nixos-rebuild switch`.

### 2. Swapping Community Rices with Tapes v2

Enable **Tapes v2** (`frost.home.apps.settings.desktop.tapes`) to pull, declaratively materialize, and atomically swap `~/.config` rices without touching your core developer dotfiles (`sled/`, `nvim/`, `zsh.d/`, browser profiles):

```nix
frost.home.apps.settings.desktop.tapes = {
  enable = true;
  gui.enable = true; # Installs the official Tapes-Deck Slint GUI
  featured = ["caelestia" "end-4" "nebula" "noctalia-libre" "serpantinum"];
};
```

```bash
# Or pull any community tape at runtime via CLI (or launch tapes-deck)
tapes install-featured caelestia
tapes install https://github.com/some_user/rice --name my-rice

# Inspect targets & hooks, swap atomically, and revert cleanly
tapes show my-rice
tapes insert my-rice
tapes eject
```

> [!TIP]
> If you manage `caelestia/` or `hypr/` exclusively through Tapes, set `frost.home.desktop.shells.caelestia.manageConfig = false` so Home Manager never overlaps Tapes-managed targets. Always run `tapes eject` before `nixos-rebuild switch` if an active tape overrides any Home Manager target.

---

## Secrets Management

Frost integrates with [SOPS-nix](https://github.com/Mic92/sops-nix). All sensitive modules accept declarative path inputs:

```nix
frost.security.secrets.sops_nix = {
  enable = true;
  defaultSopsFile = ./secrets/passwords.yaml;
};

frost.security.auth.pam = {
  enable = true;
  sopsFile = ./secrets/pam.yaml;
};
```

If `sopsFile` is omitted or set to `null`, secret extraction is cleanly bypassed, allowing evaluation in unencrypted environments.

---

## License

Licensed under the [MIT License](LICENSE).
