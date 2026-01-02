# Justfile for System Bootstrap

# List available commands
default:
    @just --list

# --- Common Setup ---

# Run basic system configurations (git, docker, time)
configure-system:
    ./scripts/configurations.sh

# Install common CLI tools (zsh, fzf, etc.)
install-cli-tools:
    ./scripts/cli-tools.sh

# Install Flatpaks
install-flatpaks:
    ./scripts/flatpak.sh

# Install Gnome Extensions
install-gnome-extensions:
    ./scripts/gnome-extensions.sh

# Install Nerd Fonts
install-fonts:
    ./scripts/nerd-fonts.p0.sh

# Install Development Tools (Go, Cargo, SDKMan)
install-dev-tools:
    ./scripts/install_golang.sh
    ./scripts/cargo-packages.sh
    ./scripts/sdkman-packages.sh

# Apply Dotfiles (using Dotbot)
apply-dotfiles:
    cd .files && ./install

# --- Distro Specific ---

# Install Fedora packages (Step 0)
fedora-step-0:
    ./scripts/fedora/00-system-update.sh

# Install Fedora packages (Step 1)
fedora-step-1:
    ./scripts/fedora/01-packages.sh

# Install Fedora packages (Step 2)
fedora-step-2:
    ./scripts/fedora/02-extras.sh

# Install Arch packages
arch-install:
    ./scripts/arch/0.sh
    ./scripts/arch/1.sh
    ./scripts/arch/2.sh
    ./scripts/arch/3.sh

# Install OpenSUSE packages
opensuse-install:
    ./scripts/opensuse/00-system-update.sh
    ./scripts/opensuse/01-packages.sh
    ./scripts/opensuse/02-extras.sh
