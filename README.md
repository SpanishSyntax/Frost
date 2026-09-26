# ❄️ Frost

A clean, modular, Flake-based **NixOS configuration** repository designed for reproducing system environments, dotfiles, and automated setups.

## 📂 Repository Structure

The configuration follows a modular structural layout:

* **`installer/`** — Declarative system installation and recovery flake apps (`frost-install`, `frost-recover`).
* **`home/`** — Home Manager configurations (user-specific dotfiles, applications, and shell configurations).
* **`hosts/`** — Host-specific configurations (hardware layouts, system options, and bootloaders).
* **`lib/`** — Custom helper functions and shared utility libraries for Nix expressions.
* **`modules/`** — Reusable NixOS system modules grouped by features (services, desktop environments, apps).
* **`secrets/`** — Enforced safety boundary for secrets text management (handled via SOPS).

---

## 🛠️ Management Commands

This configuration wraps commands using standard flake operations.

### 1. Build and Test Configuration
To test modifications safely without replacing the current boot system:
```bash
nixos-rebuild test --flake .#your-host-name
```

### 2. Switch and Apply System Layouts
To permanently build and switch to a targeted host configuration:
```bash
sudo nixos-rebuild switch --flake .#your-host-name
```

### 3. Update Lockfile Inputs
To bring the channels and inputs tracked in `flake.lock` up to current releases:
```bash
nix flake update
```

### 4. Optimize and Garbage Collect Store
To purge orphaned derivations, packages, and old systemic history links:
```bash
nix-store --gc
nix-env --delete-generations old
```

---

## 🔒 Security & Secrets Management

This repository uses **SOPS-Nix** to manage sensitive settings securely:
* Public encryption targets are defined inside `.sops.yaml`.
* Actual raw values reside as encrypted assets within the `secrets/` directory.
