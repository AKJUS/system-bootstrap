#!/usr/bin/env zsh

# ── Vicinae ───────────────────────────────────────────────────────────────────────
curl -fsSL https://vicinae.com/install.sh | bash

# ── Sway & compositor ─────────────────────────────────────────────────────────────
sudo dnf install -y sway swaylock waybar wob SwayNotificationCenter

# ── Wayland utilities ─────────────────────────────────────────────────────────────
sudo dnf install -y wl-clipboard wev grim slurp brightnessctl

# ── Notifications & OSD ───────────────────────────────────────────────────────────
sudo dnf install -y dunst
sudo dnf copr enable erikreider/swayosd
sudo dnf install -y swayosd

# ── Audio & media ─────────────────────────────────────────────────────────────────
sudo dnf install -y pavucontrol mpd mpc ncmpcpp mpv

# ── Launchers & UI ────────────────────────────────────────────────────────────────
sudo dnf install -y rofi fuzzel

# ── Terminal & file manager ───────────────────────────────────────────────────────
sudo dnf install -y kitty ranger zathura mupdf mupdf-libs
