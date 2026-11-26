- **Getting Started**
  - [Overview](README.md)
  - [Prerequisites](getting-started.md#prerequisites)
  - [Adoption Models](getting-started.md#adoption-models)
  - [Starter Template](getting-started.md#workflow-a-standalone-starter-template)
  - [External Flake Library](getting-started.md#workflow-b-external-flake-library)

- **Architecture & Foundation**
  - [The Lore](architecture.md#why-frost)
  - [Flake & Fleet Separation](architecture.md#flake--fleet-separation)
  - [Directory Hierarchy](architecture.md#directory-hierarchy)
  - [Decoupled Desktop Stack](architecture.md#decoupled-desktop-stack-dms-des-wms-portals--shells)
  - [Ephemeral Storage & Disko](architecture.md#ephemeral-storage--disko-partitioning)
  - [Out-of-Store Symlinks & Tapes v2](architecture.md#out-of-store-symlinking--tapes-v2)

- **Module Reference**
  - [System Modules (`frost.*`)](modules.md#system-modules-frost)
  - [Desktop, DEs, WMs & Portals](modules.md#desktop--display-management-frostdesktop)
  - [Hardware & Sensors](modules.md#hardware-frosthardware)
  - [Network & Security](modules.md#network-frostnetwork)
  - [Virtualization & Containers](modules.md#virtualization-frostvirtualization)
  - [Home Manager Apps (`frost.home.*`)](modules.md#user-modules-frosthome)

- **CLI & Operations**
  - [frost-install](usage.md#frost-install)
  - [frost-recover](usage.md#frost-recover)
  - [Rebuild Workflows](usage.md#everyday-rebuild-workflows)
  - [Dotfiles & Tapes v2](usage.md#dotfiles-hot-reloading--tapes-v2)
  - [SOPS Secrets Workflow](usage.md#sops-secrets-workflow)
