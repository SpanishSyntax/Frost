# Module Reference

Frost provides a unified, structured option hierarchy partitioned into system-level NixOS modules (`frost.*`) and user-level Home Manager modules (`frost.home.*`).

---

## System Modules (`frost.*`)

System modules configure hardware devices, base daemons, desktop environments, virtualization layers, and storage policies.

### Desktop & Display Management

| Option | Type | Description |
| :--- | :--- | :--- |
| `frost.desktop.wms.hyprland.enable` | boolean | Configures Hyprland Wayland compositor with UWSM session management and portal integration |
| `frost.desktop.des.gnome.enable` | boolean | Enables GNOME desktop environment and core system extensions |
| `frost.desktop.des.xfce.enable` | boolean | Enables lightweight XFCE desktop environment |
| `frost.desktop.dms.sddm.enable` | boolean | Configures SDDM display manager with Wayland support |
| `frost.desktop.dms.gdm.enable` | boolean | Configures GDM display manager |
| `frost.desktop.dms.ly.enable` | boolean | Enables lightweight TTY-based Ly display manager |
| `frost.desktop.dms.permafrost.enable` | boolean | Enables Airlock / PermaFrost Material 3 Quickshell frontend for greetd |

### Hardware & Sound

| Option | Type | Description |
| :--- | :--- | :--- |
| `frost.hardware.pipewire.enable` | boolean | Enables low-latency PipeWire sound server with ALSA, PulseAudio, and JACK emulation |
| `frost.hardware.bluetooth.enable` | boolean | Configures BlueZ daemon with modern audio codecs and Blueman GUI applet |
| `frost.hardware.networking.enable` | boolean | Configures NetworkManager or systemd-networkd network stacks |
| `frost.hardware.power.enable` | boolean | Enables TLP or auto-cpufreq battery management and thermal throttling policies |
| `frost.hardware.printing.enable` | boolean | Enables CUPS printing daemon with automatic network driver discovery |

### Security & Secrets Management

| Option | Type | Description |
| :--- | :--- | :--- |
| `frost.security.sops_nix.enable` | boolean | Enables SOPS-nix runtime decryption using host age keys |
| `frost.security.sops_nix.defaultSopsFile` | path | Path to encrypted YAML or JSON secrets file |
| `frost.security.pam.enable` | boolean | Configures PAM modules, including YubiKey U2F multi-factor auth |
| `frost.security.polkit.enable` | boolean | Enables Polkit daemon with user desktop authentication agent |
| `frost.security.gnome_keyring.enable` | boolean | Enables GNOME Keyring daemon with PAM auto-unlocking |
| `frost.security.firewall.enable` | boolean | Configures iptables / nftables declarative firewall rules |
| `frost.security.onepassword.enable` | boolean | Installs 1Password CLI and system authentication helper |

### System Services & Networking

| Option | Type | Description |
| :--- | :--- | :--- |
| `frost.services.ssh.enable` | boolean | Hardened OpenSSH daemon (disables root login, enforces pubkey auth) |
| `frost.services.tailscale.enable` | boolean | Enables Tailscale mesh VPN daemon with routing options |
| `frost.services.wireguard.enable` | boolean | Declarative WireGuard tunnels and key management |
| `frost.services.syncthing.enable` | boolean | Declarative folder synchronization with systemd user unit |
| `frost.services.caddy.enable` | boolean | Modern reverse proxy with automatic HTTPS certificate provisioning |
| `frost.services.cloudflared.enable` | boolean | Cloudflare Zero Trust tunnel daemon |
| `frost.services.adguard.enable` | boolean | AdGuard Home DNS sinkhole and ad-blocking server |

### Storage & Impermanence

| Option | Type | Description |
| :--- | :--- | :--- |
| `frost.storage.impermanence.enable` | boolean | Mounts root filesystem on ephemeral tmpfs or resets Btrfs subvolume on boot |
| `frost.storage.btrfs_rollback.enable` | boolean | Automatically restores blank `@` subvolume during initrd stage |
| `frost.storage.disko.enable` | boolean | Declares automated disk formatting and partitioning schemes |
| `frost.storage.zfs.enable` | boolean | Configures OpenZFS kernel modules and automated snapshot maintenance |

### Virtualization & Containers

| Option | Type | Description |
| :--- | :--- | :--- |
| `frost.virtualization.docker.enable` | boolean | Installs Docker daemon with rootless execution options |
| `frost.virtualization.podman.enable` | boolean | Enables Podman rootless container runtime |
| `frost.virtualization.microvm.enable` | boolean | Declarative lightweight hypervisor VMs managed by systemd |
| `frost.virtualization.libvirt.enable` | boolean | Enables KVM/QEMU hypervisor with Virt-Manager UI support |
| `frost.virtualization.bottles.enable` | boolean | Enables Bottles / Wine gaming container runtime |

---

## User Modules (`frost.home.*`)

User modules configure desktop tools, terminal utilities, development compilers, and office software managed by Home Manager.

### Option Tree

User applications are organized under `frost.home.applications`:

- **`development`**:
  - `editors`: `nvim`, `vscode`, `zed`, `android_studio`
  - `tools`: `git`, `heimdall`, `postman`, `dbeaver`
  - `langs`: `bash`, `cpp`, `go`, `java`, `js`, `latex`, `lua`, `markdown`, `nginx`, `nix`, `python`, `rust`, `toml`, `typst`, `yaml`
- **`graphics`**:
  - `raster`: `gimp`, `sly`
  - `vector`: `inkscape`
  - `cad`: `blender`, `model_viewer`
  - `viewers`: `gnome_image_viewer`, `gnome_image_editor`
  - `scanning`: `gnome_scanner`, `gnome_ocr`
- **`media`**:
  - `audio`: `spotify`, `gnome_radio`, `pwvucontrol`
  - `video`: `anime`, `netflix`, `obs`, `kdenlive`, `gnome_video_player`
- **`network`**:
  - `browsers`: `chrome`, `firefox`, `tor`, `zen`
  - `chat`: `discord`, `teams`, `telegram`, `tut`, `whatsapp`
  - `transfer`: `aria2`, `gnome_torrents`, `parabolic`
  - `remote`: `dnsutils`, `eduvpn`, `gnome_network_displays`, `iperf`, `kde_connect`, `remmina`
- **`office`**:
  - `docs`: `libreoffice`, `obsidian`, `marktext`, `rnote`, `gnome_markdown`, `todoist`
  - `readers`: `zathura`, `sioyek`, `calibre`, `foliate`, `zlibrary`, `gnome_document_viewer`
  - `tools`: `pandoc`, `ghostscript`, `mermaid`, `stirling`, `autofirma`, `bento_pdf`, `zotero`
- **`science`**:
  - `math`: `octave`
  - `gis`: `qgis`
  - `diagrams`: `drawio`
  - `electronics`: `kicad`
- **`system`**:
  - `shell`: `bat`, `curl`, `eza`, `fastfetch`, `file`, `fzf`, `glow`, `jq`, `kitty`, `magika`, `pay_respects`, `pdfgrep`, `ripgrep`, `starship`, `tmux`, `tree`, `wget`, `zoxide`, `zsh`
  - `core`: `bluetooth`, `sqlite`, `usbutils`, `zip`
  - `desktop`: `gnome_characters`, `gnome_file_roller`, `gnome_files`, `gnome_system_monitor`, `thunar`
- **`icebergs`**:
  - Integrations for ecosystem tools: `barograph`, `basecamp`, `beacon`, `borealis`, `goggles`, `igloo`, `lantern`, `permafrost`, `prism`, `rime`, `searchlight`, `shards`, `sled`, `snowpack`, `skald`
- **`ai`**:
  - `antigravity`, `flox`, `n8n`, `opencode`

### Example Configuration

```nix
{ pkgs, ... }: {
  frost.home.applications = {
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
    icebergs = {
      sled.enable = true;
      borealis.enable = true;
    };
  };
}
```
