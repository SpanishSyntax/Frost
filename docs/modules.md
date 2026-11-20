# Module Reference

Frost provides a strict 2-level option hierarchy for system-level NixOS modules (`frost.<domain>.<category>.<module>`) and XDG-categorized user-level Home Manager modules (`frost.home.*`).

---

## System Modules (`frost.*`)

### System (`frost.system.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `boot` | `console`, `plymouth` | TTY console settings and Plymouth boot splash (`source = "adi1090x" \| "bgrt" \| "catppuccin" \| "builtin" \| "custom"` with build-time Lanczos `.webm`/`.mp4`/`.gif`/PNG-dir compiler, `fit = "contain" \| "cover" \| "native"`, and lazy frame loading) |
| `locale` | `datetime`, `fonts`, `locales` | Timezone, NTP, system font stack, and locale defaults |
| `runtime` | `environment`, `fhs`, `home_manager` | Base system packages, `nix-ld` / FHS compatibility, and Home Manager integration |
| `storage` | `btrfs_rollback`, `impermanence`, `trash`, `zfs` | Ephemeral root rollback, `/persist` bind-mounts, trash management, and OpenZFS |

### Desktop & Display Management (`frost.desktop.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `dms` | `permafrost`, `greetd`, `sddm`, `gdm`, `ly`, `lightdm`, `cosmic_greeter` | Decoupled display managers with unified `frost.desktop.dms.defaultSession` resolution |
| `des` | `gnome`, `plasma`, `cosmic`, `xfce`, `cinnamon`, `mate`, `lxqt`, `budgie` | Full desktop environments (co-installable without portal or service conflicts) |
| `wms` | `hyprland`, `niri`, `sway`, `river`, `mango`, `i3`, `bspwm`, `awesome`, `qtile` | Wayland and X11 window managers with session-scoped Polkit agents, IIO rotation (`hyprland.iioOutput`, `hyprland.iioTabletModeOnly`, `sway` `rot8`), and XWayland toggles (`niri.xwayland.enable`, `mango.xwayland.enable`) |
| `portals` | `xdg`, `fjord` | Session-scoped XDG Desktop Portal unifier (`<session>-portals.conf`) and Fjord (Wormhole Material 3) portal |

### Hardware (`frost.hardware.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `audio` | `pipewire` | Low-latency PipeWire sound server with ALSA, PulseAudio, and JACK emulation |
| `peripherals` | `bluetooth`, `printing`, `uinput` | BlueZ stack, CUPS printing + discovery, and `uinput` device permissions |
| `power` | `power` (`frost.hardware.power`) | Laptop power profiles, TLP / thermal management, and battery charge thresholds |
| `sensors` | `iio`, `wluma` | `iio-sensor-proxy` accelerometer/ALS daemon and `wluma` Wayland auto-brightness (`capturer = "none" \| "wayland"`, `keyboardBacklight`, udev backlight rules) |

### Network (`frost.network.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `stack` | `firewall`, `networking` | Declarative nftables/iptables firewall and NetworkManager / networkd (with non-blocking `waitOnline` boot toggle) |
| `edge` | `adguard`, `caddy`, `cloudflared` | DNS sinkhole, automatic HTTPS reverse proxy, and Cloudflare Zero Trust tunnels |
| `remote` | `kde_connect`, `ssh`, `wayvnc` | Hardened OpenSSH daemon, KDE Connect firewall/daemon, and WayVNC |
| `sync` | `google_drive`, `syncthing` | System-level Syncthing and Google Drive sync helpers |
| `vpn` | `eduvpn`, `openvpn`, `tailscale`, `wireguard` | Mesh and traditional VPN tunnels |

### Security (`frost.security.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `auth` | `pam`, `polkit`, `yubikey` | PAM U2F/FIDO2 authentication, Polkit daemon, and YubiKey smartcard/udev rules |
| `secrets` | `gnome_keyring`, `onepassword`, `sops_nix` | SOPS-nix runtime decryption, GNOME Keyring, and 1Password CLI/GUI integration |

### Virtualization (`frost.virtualization.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `containers` | `compose2nix`, `docker`, `oci`, `podman` | Docker (with `enableOnBoot` socket activation & weekly `autoPrune`), Podman, and declarative OCI container runtimes |
| `vms` | `libvirt`, `microvm`, `virtualbox` | KVM/QEMU hypervisor, declarative MicroVMs, and VirtualBox |
| `stacks` | `immich`, `jellyfin`, `pgadmin` | Pre-wired self-hosted containerized service stacks (with `pgadmin.autoStart`) |

### Programs (`frost.programs.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `flatpak` | `flatpak` (`default`), `bottles`, `flatseal`, `museum` | Flatpak runtime and curated desktop Flatpak apps |
| `gaming` | `steam` | Steam + Gamemode / Gamescope gaming stack |
| `utilities` | `gnome_disk_usage`, `gnome_disks`, `iamb` | System-level disk and CLI utilities |

---

## User Modules (`frost.home.*`)

User modules live under `frost.home.apps.*` (following XDG desktop categories), `frost.home.desktop.*`, `frost.home.environment.*`, and `frost.home.services.*`.

### Applications (`frost.home.apps.*`)

#### AI & Agent Tooling (`frost.home.apps.ai.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `ai` | `antigravity`, `beacon`, `flox`, `n8n`, `opencode`, `sled` | AI coding agents, Sled atomic MCP server bridge, learning harness, and workflow automation |

#### Development (`frost.home.apps.development.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `editors` | `nvim`, `vscode`, `zed`, `android_studio` | Modal terminal and graphical IDEs with out-of-store config support |
| `tools` | `basecamp`, `dbeaver`, `git`, `heimdall`, `postman`, `prism` | DevShell scaffolding, Git/SSH signing, database & API clients, and terminal UI engine |
| `langs` | `bash`, `cpp`, `go`, `java`, `js`, `latex`, `lua`, `markdown`, `nginx`, `nix`, `python`, `rust`, `toml`, `typst`, `yaml` | Language toolchains, LSP servers, formatters, and linters |

#### Gaming (`frost.home.apps.gaming.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `launchers` | `gamemode`, `heroic`, `waylandcraft` | Feral GameMode, Heroic Games Launcher, and native Wayland Minecraft Fabric stack (`prismlauncher` + `waylandcraft.jar`) |

#### Graphics (`frost.home.apps.graphics.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `cad` | `blender`, `model_viewer` | 3D modeling, rendering, and mesh inspection |
| `raster` | `gimp`, `sly` | Raster image editing and photography suites |
| `scanning` | `gnome_ocr`, `gnome_scanner` | Document scanning and optical character recognition |
| `vector` | `inkscape` | Vector graphics and SVG authoring |
| `viewers` | `gnome_image_editor`, `gnome_image_viewer` | Fast desktop image viewing and quick annotation |

#### Media (`frost.home.apps.media.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `audio` | `cozy`, `gnome_radio`, `pwvucontrol`, `skald`, `spotify` | Audiobook players, PipeWire mixer, Skald neural M4B audiobook compiler, and streaming |
| `video` | `anime`, `gnome_video_player`, `kdenlive`, `netflix`, `obs` | Non-linear video editing, OBS screen recording/streaming, and media playback |

#### Network (`frost.home.apps.network.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `browsers` | `chrome`, `firefox`, `tor`, `zen` | Hardened and daily-driver web browsers |
| `chat` | `discord`, `teams`, `telegram`, `tut`, `whatsapp` | Desktop and TUI messaging clients |
| `remote` | `dnsutils`, `eduvpn`, `gnome_network_displays`, `iperf`, `kde_connect`, `mappers`, `openssl`, `remmina` | Network diagnostics, VPN clients, Miracast displays, and RDP/VNC clients |
| `transfer` | `aria2`, `gnome_torrents`, `parabolic` | Multi-connection downloaders, BitTorrent, and media streams |

#### Office & Publishing (`frost.home.apps.office.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `docs` | `gnome_markdown`, `libreoffice`, `marktext`, `obsidian`, `rnote`, `todoist` | Office suite, knowledge graphs, handwritten notes, and task management |
| `readers` | `calibre`, `foliate`, `gnome_document_viewer`, `goggles`, `sioyek`, `zathura`, `zlibrary` | Academic PDF readers (`sioyek`, `zathura`), e-book managers, and Goggles native GFM viewer |
| `tools` | `autofirma`, `bento_pdf`, `ghostscript`, `gnome_pomodoro`, `mermaid`, `pandoc`, `searchlight`, `snowpack`, `stirling`, `zotero` | Snowpack Typst/LaTeX compiler, Searchlight fuzzy PDF search, Zotero citations, and PDF tooling |

#### Science & Engineering (`frost.home.apps.science.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `diagrams` | `drawio`, `lantern` | Technical diagramming and Lantern interactive simulation explainer compiler |
| `electronics` | `kicad` | Schematic capture and PCB layout suite |
| `gis` | `qgis` | Geographic information system and spatial analysis |
| `math` | `barograph`, `octave` | Barograph multi-backend figure extraction engine and numerical computing |

#### Settings & Ricing (`frost.home.apps.settings.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `desktop` | `helm`, `nwg_look`, `tapes` | Helm Hyprland configuration studio, GTK theme switcher, and Tapes v2 (`enable`, `gui.enable`, `featured`) |
| `packages` | `gnome_software` | Graphical software center |
| `security` | `gnome_seahorse`, `onepassword`, `pass`, `sops`, `vulnix` | Password managers, PGP/SSH keyrings, SOPS CLI, and Nix vulnerability scanner |

#### System & Utilities (`frost.home.apps.system.*`, `frost.home.apps.utility.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `core` | `bluetooth`, `sqlite`, `usbutils`, `zip` | Core CLI and archive utilities |
| `desktop` | `gnome_characters`, `gnome_file_roller`, `gnome_files`, `gnome_system_monitor`, `thunar` | Graphical file managers, archive extractors, and system monitors |
| `shell` | `bat`, `curl`, `eza`, `fastfetch`, `file`, `fzf`, `glow`, `jq`, `kitty`, `magika`, `pay_respects`, `pdfgrep`, `ripgrep`, `starship`, `tmux`, `tree`, `wget`, `zoxide`, `zsh` | GPU-accelerated terminal (`kitty`), Zsh + Starship prompt, and modern Unix CLI replacements |
| `virtualization` | `boxbuddy`, `devbox`, `distrobox`, `docker`, `kontainer`, `virt_manager` | Distrobox container management, Devbox environments, and Libvirt GUI |
| `accessories` | `calculator`, `gnome_calculator`, `gnome_calendar`, `gnome_clocks`, `gnome_fretboard`, `gnome_typing`, `gnome_weather`, `memorado`, `rime`, `rss` | Rime batch filename sanitizer, desktop calculators, clocks, and flashcards |

### Desktop Shells & Tools (`frost.home.desktop.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `shells` | `igloo` | Caelestia Quickshell desktop shell (`compositor`, `manageConfig`, `systemd.enable`) |
| `tools` | `awww`, `borealis`, `igloo_cli`, `shards` | Dynamic atmospheric wallpaper daemon (`borealis`), Wayland clipboard/emoji overlay (`shards`), and shell CLI |

### Environment & Services (`frost.home.environment.*`, `frost.home.services.*`)

| Category | Modules | Description |
| :--- | :--- | :--- |
| `environment` | `configsPath`, `mutable`, `extraConfigs`, `mkSource`, `fonts`, `gtk`, `xdg`, `ignores` | Centralized dotfile path resolver (pure store vs live out-of-store symlinks), theming, and XDG directories |
| `services` | `google_drive`, `syncthing` | User-level Rclone Google Drive FUSE mount and Syncthing continuous file synchronization |

### Example Configuration

```nix
{ config, ... }: {
  frost.home = {
    apps = {
      ai.sled.enable = true;
      development = {
        editors.nvim.enable = true;
        tools.git.enable = true;
        langs = {
          nix.enable = true;
          rust.enable = true;
          typst.enable = true;
          python.enable = true;
        };
      };
      settings.desktop.tapes.enable = true;
      system.shell = {
        kitty.enable = true;
        zsh.enable = true;
        starship.enable = true;
        zoxide.enable = true;
        ripgrep.enable = true;
        eza.enable = true;
        fzf.enable = true;
      };
      network.browsers.firefox.enable = true;
      office.readers.sioyek.enable = true;
    };

    desktop = {
      shells.igloo = {
        enable = true;
        manageConfig = true;
      };
      tools = {
        borealis.enable = true;
        igloo_cli.enable = true;
        shards.enable = true;
      };
    };

    environment = {
      configsPath = "${config.home.homeDirectory}/Fleet/configs/home";
      extraConfigs = ["hypr"];
      fonts.enable = true;
      gtk.enable = true;
      xdg.enable = true;
    };
  };
}
```
