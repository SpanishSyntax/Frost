# Getting Started

This guide walks through deploying a system using Frost, either as a standalone starter template or as an external Flake library in a private fleet configuration.

---

## Prerequisites

- **Nix** with experimental features enabled (`nix-command`, `flakes`):
  ```bash
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  ```
- **NixOS target machine** or virtual machine with UEFI support and network connectivity.
- A target disk device matching your Disko declarations (e.g. `/dev/nvme0n1` or `/dev/sda`).

---

## Adoption Models

Frost supports two primary architectural workflows:

| Model | Target Use Case | Repository Structure |
| :--- | :--- | :--- |
| **Starter Template (Fork & Clone)** | Standalone desktop or single machine where configuration and modules live together | Fork of `SpanishSyntax/Frost` |
| **External Flake Library (Private Fleet)** | Multi-machine fleet with encrypted private secrets, distinct hardware profiles, and private git tracking | Private repo importing `inputs.frost` |

---

## Workflow A: Standalone Starter Template

### 1. Clone the Repository

```bash
git clone https://github.com/SpanishSyntax/Frost.git ~/Frost
cd ~/Frost
```

### 2. Configure Starter Profiles

Frost ships with two pre-configured host archetypes:

- **Workstation** (`hosts/workstation/`): Hyprland Wayland compositor, GNOME Desktop Environment option, SDDM / Caelestia greeter, PipeWire low-latency audio, and NVMe Disko partitioning.
- **Server** (`hosts/server/`): Headless server setup with OpenSSH, Docker OCI container runtime, and SATA Disko partitioning.

Inspect `hosts/workstation/configuration.nix` or `hosts/server/configuration.nix` and enable the modules you need.

### 3. Set User Credentials

Edit `hosts/workstation/users.nix`:

```nix
users.users.frost = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  initialPassword = "change-me-immediately";
  # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
};
```

### 4. Build and Switch

Test the configuration without permanently setting the bootloader generation:

```bash
nixos-rebuild test --flake .#workstation
```

Once verified, commit the generation to your bootloader:

```bash
sudo nixos-rebuild switch --flake .#workstation
```

---

## Workflow B: External Flake Library

In a private fleet repository, import Frost as an external Flake input. This cleanly decouples generic modules from private host identities and secrets.

### 1. Define `flake.nix`

```nix
{
  description = "Private Fleet NixOS Infrastructure";

  inputs = {
    frost.url = "github:SpanishSyntax/Frost";
    nixpkgs.follows = "frost/nixpkgs";
  };

  outputs = { self, frost, nixpkgs, ... } @ inputs: let
    inherit (frost.lib) mkSystem;
  in {
    nixosConfigurations = {
      workstation = mkSystem {
        host = "workstation";
        modules = [
          ./hosts/workstation/configuration.nix
        ];
        specialArgs = { inherit self; };
      };
    };
  };
}
```

### 2. Define `hosts/workstation/configuration.nix`

Because `mkSystem` automatically injects Frost's system modules, base configuration, and bootloader options, your host configuration only declares hardware and module toggles:

```nix
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./users.nix
  ];

  frost = {
    desktop.wms.hyprland.enable = true;
    hardware.pipewire.enable = true;
    hardware.bluetooth.enable = true;
    security.polkit.enable = true;
    system.home_manager.enable = true;
  };
}
```

### 3. Deploy

```bash
sudo nixos-rebuild switch --flake .#workstation
```
