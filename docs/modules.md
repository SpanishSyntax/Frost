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

- **`ai`**: `antigravity`, `beacon`, `flox`, `n8n`, `opencode`, `sled`
- **`development`**:
  - `editors`: `nvim`, `vscode`, `zed`, `android_studio`
  - `tools`: `basecamp`, `dbeaver`, `git`, `heimdall`, `postman`, `prism`
  - `langs`: `bash`, `cpp`, `go`, `java`, `js`, `latex`, `lua`, `markdown`, `nginx`, `nix`, `python`, `rust`, `toml`, `typst`, `yaml`
- **`gaming.launchers`**: `gamemode`, `heroic`, `waylandcraft`
- **`graphics`**:
  - `cad`: `blender`, `model_viewer`
  - `raster`: `gimp`, `sly`
  - `scanning`: `gnome_ocr`, `gnome_scanner`
  - `vector`: `inkscape`
  - `viewers`: `gnome_image_editor`, `gnome_image_viewer`
- **`media`**:
  - `audio`: `cozy`, `gnome_radio`, `pwvucontrol`, `skald`, `spotify`
  - `video`: `anime`, `gnome_video_player`, `kdenlive`, `netflix`, `obs`
- **`network`**:
  - `browsers`: `chrome`, `firefox`, `tor`, `zen`
  - `chat`: `discord`, `teams`, `telegram`, `tut`, `whatsapp`
  - `remote`: `dnsutils`, `eduvpn`, `gnome_network_displays`, `iperf`, `kde_connect`, `mappers`, `openssl`, `remmina`
  - `transfer`: `aria2`, `gnome_torrents`, `parabolic`
- **`office`**:
  - `docs`: `gnome_markdown`, `libreoffice`, `marktext`, `obsidian`, `rnote`, `todoist`
  - `readers`: `calibre`, `foliate`, `gnome_document_viewer`, `goggles`, `sioyek`, `zathura`, `zlibrary`
  - `tools`: `autofirma`, `bento_pdf`, `ghostscript`, `gnome_pomodoro`, `mermaid`, `pandoc`, `searchlight`, `snowpack`, `stirling`, `zotero`
- **`science`**:
  - `diagrams`: `drawio`, `lantern`
  - `electronics`: `kicad`
  - `gis`: `qgis`
  - `math`: `barograph`, `octave`
- **`settings`**:
  - `desktop`: `helm`, `nwg_look`, `tapes` (`enable`, `gui.enable` for `tapes-deck`, `featured = ["caelestia" "end-4" "nebula" "noctalia-libre" "serpantinum"]`)
  - `packages`: `gnome_software`
  - `security`: `gnome_seahorse`, `onepassword`, `pass`, `sops`, `vulnix`
- **`system`**:
  - `core`: `bluetooth`, `sqlite`, `usbutils`, `zip`
  - `desktop`: `gnome_characters`, `gnome_file_roller`, `gnome_files`, `gnome_system_monitor`, `thunar`
  - `shell`: `bat`, `curl`, `eza`, `fastfetch`, `file`, `fzf`, `glow`, `jq`, `kitty`, `magika`, `pay_respects`, `pdfgrep`, `ripgrep`, `starship`, `tmux`, `tree`, `wget`, `zoxide`, `zsh`
  - `virtualization`: `boxbuddy`, `devbox`, `distrobox`, `docker`, `kontainer`, `virt_manager`
- **`utility.accessories`**: `calculator`, `gnome_calculator`, `gnome_calendar`, `gnome_clocks`, `gnome_fretboard`, `gnome_typing`, `gnome_weather`, `memorado`, `rime`, `rss`

### Desktop Shells & Tools (`frost.home.desktop.*`)

- **`shells`**: `igloo` (`manageConfig`, `compositor`, `systemd.enable`)
- **`tools`**: `awww`, `borealis` (`backend`, `interval`, `telemetryInterval`, `wallpaperDir`, `extraWallpaperDirs`, `settings`, `manageConfig`, `systemd.enable`), `igloo_cli`, `shards` (`systemd.enable`)

### Environment & Services (`frost.home.environment.*`, `frost.home.services.*`)

- **`environment`**: `configsPath`, `mutable`, `extraConfigs`, `mkSource`, `mkPureSource`, `mkImpureSource`, `fonts`, `gtk`, `xdg`, `ignores`
- **`services`**: `google_drive`, `syncthing`

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
