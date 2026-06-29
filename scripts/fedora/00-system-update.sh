#!/usr/bin/env bash

# ── System update ─────────────────────────────────────────────────────────────────
# check-update exits 100 when updates are available; || true prevents set -e abort
sudo dnf check-update || true
sudo dnf upgrade -y

# ── Base deps ─────────────────────────────────────────────────────────────────────
sudo dnf install -y \
    ca-certificates curl wget gnupg2 \
    util-linux-user \
    fuse3 \
    fedora-workstation-repositories

# fuse3: FUSE 2 is deprecated in Fedora 44; fuse3 is the current package
# util-linux-user: provides chsh — installed before it's called below

# ── PipeWire audio stack ──────────────────────────────────────────────────────────
sudo dnf install -y \
    pipewire pipewire-alsa pipewire-pulseaudio pipewire-jack-audio-connection-kit \
    wireplumber

# pipewire-alsa alone is insufficient; pulseaudio compat + wireplumber session
# manager are required for a working audio stack

# ── RPM Fusion ───────────────────────────────────────────────────────────────────
FEDORA_VER=$(rpm -E %fedora)
sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VER}.noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VER}.noarch.rpm"

# ── Shell ─────────────────────────────────────────────────────────────────────────
sudo dnf install -y zsh fzf git

chsh -s "$(which zsh)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
