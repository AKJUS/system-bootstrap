#!/usr/bin/env zsh

# ── Terminal & CLI tools ──────────────────────────────────────────────────────────
sudo dnf -y install \
    alacritty kitty bat bottom btop curl fd-find fzf git htop neofetch \
    wl-clipboard yq jq net-tools hyperfine asciinema gdu fastfetch

# ── System utilities ──────────────────────────────────────────────────────────────
sudo dnf install -y \
    unzip stress stacer xsensors fontconfig pipx \
    libsecret libsecret-devel libgnome-keyring toolbox wev

# ── Compilers & build tools ───────────────────────────────────────────────────────
sudo dnf install -y \
    gcc g++ clang clangd clang-format clang-analyzer clang-tools-extra \
    llvm llvm-devel clang-devel compiler-rt lld lldb \
    make cmake meson ninja-build ccache flex bison gperf \
    readline-devel libreadline-dev libffi-devel openssl-devel openssl \
    build-essential dfu-util

# ── Debugging & profiling ─────────────────────────────────────────────────────────
sudo dnf install -y \
    gdb valgrind strace ltrace perf wireshark-cli protobuf-compiler

# ── Development libraries ─────────────────────────────────────────────────────────
sudo dnf install -y \
    gtk3-devel gtk4 gtk4-devel gobject-introspection gobject-introspection-devel \
    webkit2gtk4.0-devel \
    libXcursor-devel libXrandr-devel libXi-devel libXinerama-devel libXxf86vm- \
    mesa-libGL mesa-libGL-devel mesa-libgbm mesa-libglapi mesa-libEGL mesa-libOSMesa \
    mesa-filesystem

# ── Media & codecs ────────────────────────────────────────────────────────────────
sudo dnf -y install vlc mpv gstreamer1-vaapi
sudo dnf -y install ffmpeg ffmpeg-devel --allowerasing
sudo dnf -y install gstreamer1-plugins-{good-\*,base} gstreamer1-plugin-openh264 --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf groupupdate multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# ── GPU & video decode ────────────────────────────────────────────────────────────
sudo dnf install -y \
    libva libva-utils libva-vdpau-driver libvdpau-va-gl \
    mesa-va-drivers mesa-vdpau-drivers mesa-dri-drivers

if lspci | grep -i amd | grep -i vga > /dev/null; then
    echo "AMD GPU found."
    sudo dnf install radeontop
fi

if lspci | grep -i intel | grep -i vga > /dev/null; then
    echo "Intel GPU found."
    sudo dnf install intel-media-driver
fi

# ── Typesetting & fonts ───────────────────────────────────────────────────────────
sudo dnf install -y texlive-base texlive-xetex fira-code-fonts

# ── UI / Desktop ──────────────────────────────────────────────────────────────────
sudo dnf -y install gnome-tweaks gnome-extensions-app

# ── Virtualization ────────────────────────────────────────────────────────────────
sudo dnf install -y qemu qemu-kvm libvirt virt-install bridge-utils

# ── Streaming & capture ───────────────────────────────────────────────────────────
sudo dnf install -y obs-studio obs-studio-libs v4l2loopback

# ── Document viewers ──────────────────────────────────────────────────────────────
sudo dnf install -y zathura mupdf

# ── Languages ─────────────────────────────────────────────────────────────────────
sudo dnf install -y crystal
