#!/usr/bin/env zsh
# Fedora 44 dev/streaming setup
# Tested against F44 (LLVM 22, GCC 16, TeXLive 2025, DNF5 backend)

# ── Terminal & CLI tools ──────────────────────────────────────────────────────────
sudo dnf -y install \
    alacritty kitty bat btop curl fd fzf git htop \
    wl-clipboard yq jq net-tools hyperfine asciinema gdu fastfetch

# ── System utilities ──────────────────────────────────────────────────────────────
sudo dnf install -y \
    unzip stress xsensors fontconfig pipx \
    libsecret libsecret-devel toolbox wev nmcli foot tig buildah mtr nmap httpie ripgrep

# ── Compilers & build tools ───────────────────────────────────────────────────────
sudo dnf install -y \
    gcc gcc-c++ clang clangd clang-format clang-analyzer clang-tools-extra \
    llvm llvm-devel clang-devel compiler-rt lld lldb \
    make cmake meson ninja-build ccache flex bison gperf \
    readline-devel libffi-devel openssl-devel openssl \
    dfu-util

# ── Debugging & profiling ─────────────────────────────────────────────────────────
sudo dnf install -y \
    gdb valgrind strace ltrace perf wireshark-cli protobuf-compiler

# ── Development libraries ─────────────────────────────────────────────────────────
sudo dnf install -y \
    gtk3-devel gtk4 gtk4-devel gobject-introspection gobject-introspection-devel \
    webkitgtk6.0-devel \
    libXcursor-devel libXrandr-devel libXi-devel libXinerama-devel \
    libXxf86vm-devel \
    mesa-libGL mesa-libGL-devel mesa-libgbm mesa-libglapi mesa-libEGL \
    mesa-filesystem

# ── Media & codecs ────────────────────────────────────────────────────────────────
sudo dnf -y install vlc mpv gstreamer1-vaapi imv
sudo dnf -y install ffmpeg ffmpeg-devel --allowerasing
sudo dnf -y install gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1-plugin-openh264
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

# ── GPU & video decode ────────────────────────────────────────────────────────────
sudo dnf install -y \
    libva libva-utils \
    mesa-va-drivers

if lspci | grep -i amd | grep -i vga > /dev/null; then
    echo "AMD GPU found."
    sudo dnf install -y radeontop
fi

if lspci | grep -i intel | grep -i vga > /dev/null; then
    echo "Intel GPU found."
    sudo dnf install -y intel-media-driver
fi

# ── Typesetting & fonts ───────────────────────────────────────────────────────────
# TeXLive 2025 is modularized in F44 — install via scheme or collections
sudo dnf install -y texlive-scheme-basic texlive-collection-xetex fira-code-fonts

# texlive-base + texlive-xetex may still resolve but scheme-based names are canonical in F44

# ── UI / Desktop ──────────────────────────────────────────────────────────────────
sudo dnf -y install gnome-tweaks gnome-extensions-app

# ── Virtualization ────────────────────────────────────────────────────────────────
# Note: F44 drops QEMU i686 32-bit host builds; 64-bit only going forward
sudo dnf install -y qemu-kvm libvirt virt-install bridge-utils

# qemu meta-package split; qemu-kvm is the correct target for KVM guests

# ── Streaming & capture ───────────────────────────────────────────────────────────
sudo dnf install -y v4l2loopback

# ── Document viewers ──────────────────────────────────────────────────────────────
sudo dnf install -y zathura mupdf