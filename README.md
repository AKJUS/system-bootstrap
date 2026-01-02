# System Bootstrap

A comprehensive, multi-distro dotfiles and system bootstrap configuration. Designed to set up a premium development environment on **Fedora**, **Arch Linux**, and **OpenSUSE**.

<p align="center">
  <img src="assets/fedora-black-4k.png" width="48%" alt="Fedora Wallpaper">
  <img src="assets/opensuse-black-4k.png" width="48%" alt="OpenSUSE Wallpaper">
</p>

## 📋 Table of Contents

- [Features](#-features)
- [Structure](#-structure)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
  - [Using Just (Recommended)](#using-just-recommended)
  - [Manual Execution](#manual-execution)
- [Configuration Details](#-configuration-details)
- [Notes](#-notes)
- [License](#-license)

## 🚀 Features

*   **Multi-Distro Support**: Tailored scripts for Fedora, Arch, and OpenSUSE.
*   **Dotfiles Management**: Powered by [Dotbot](https://github.com/anishathalye/dotbot) (installed via `binary-dist.sh`).
*   **Dev Environment**: Deploys a full stack: Zsh (Oh-My-Zsh), Neovim, Tmux (TPM), Go, Rust, Java (SDKMan).
*   **Desktop Rice**: Configuration for Hyprland, Gnome extensions, stunning wallpapers, and Alacritty/Kitty/WezTerm theming.

## 📂 Structure

```
.system-bootstrap/
├── .files/               # Dotfiles configuration (Zsh, Neovim, Tmux, etc.)
│   ├── arch+hypr/        # Arch-specific configs
│   ├── fedora/           # Fedora-specific configs
│   ├── opensuse/         # OpenSUSE-specific configs
│   └── install.conf.yaml # Main Dotbot configuration
├── scripts/              # Installation & setup scripts
│   ├── arch/             # Arch package installation steps
│   ├── fedora/           # Fedora package installation steps
│   ├── opensuse/         # OpenSUSE package installation steps
│   └── ...               # Common setup scripts (Flatpak, Fonts, Dev Tools)
├── assets/               # Wallpapers and resources
├── Justfile              # Command runner for orchestration
└── README.md             # This file
```

## 🛠 Prerequisites

*   **Git**: To clone the repo.
*   **Just**: Recommended runner (optional, can run scripts manually).
    *   *Fedora*: `sudo dnf install just`
    *   *Arch*: `sudo pacman -S just`
    *   *Suse*: `sudo zypper install just`

## 📦 Installation

Clone the repository:
```bash
git clone --recursive https://github.com/limpid-kzonix/system-bootstrap.git ~/.system-bootstrap
cd ~/.system-bootstrap
```

### Using Just (Recommended)

View all available commands:
```bash
just
```

**Typical Workflow:**

1.  **System Setup**:
    ```bash
    just configure-system   # Setup git, docker, time
    ```

2.  **Distro Packages** (Choose your fighter):
    ```bash
    just fedora-step-0      # Update & install core repo
    just fedora-step-1      # Install core packages
    # ...
    ```
    *Or for Arch:*
    ```bash
    just arch-install
    ```

3.  **Cross-Platform Tools**:
    ```bash
    just install-cli-tools        # Zsh, fzf, etc.
    just install-zsh-plugins      # Syntax highlighting, autosuggestions
    just install-binaries         # Dotbot, Yazi, Neovim
    just install-gnome-extensions # If using Gnome
    just install-fonts            # Nerd Fonts
    just install-flatpaks         # Desktop apps
    just install-dev-tools        # Go, Rust, etc.
    ```

4.  **Link Dotfiles**:
    ```bash
    just apply-dotfiles
    ```

### Manual Execution

If you prefer to run scripts one-by-one (e.g., to handle reboots), simply navigate to `scripts/` and execute them.

**Fedora Example:**
```bash
./scripts/fedora/exec.0.sh
# Reboot if kernel updated
./scripts/fedora/exec.1.sh
./scripts/configurations.sh
./scripts/install_golang.sh
```

## 🔧 Configuration Details

*   **Zsh**: Custom detailed configuration with Oh-My-Zsh and plugins.
*   **Neovim**: Lua-based configuration in `.files/nvim`.
*   **Terminal**: Unified themes for Alacritty, Kitty, and WezTerm.
*   **Hyprland**: (Arch only) Tiling window manager setup in `.files/arch+hypr`.

## ⚠️ Notes

*   **Docker**: The `configure-system` script adds your user to the `docker` group. **You must log out and log back in** for this to take effect.
*   **Reboots**: Some package installation scripts (kernel updates, drivers) may require a reboot.

## 📄 License
MIT
