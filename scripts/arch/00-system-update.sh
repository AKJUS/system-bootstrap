#!/usr/bin/env bash

# Update system
sudo pacman -Syu --noconfirm

sudo pacman -S \
  plasma-integration \
  kde-gtk-config \
  breeze \
  breeze-gtk \
  qt5ct \
  qt6ct

sudo pacman -S --noconfirm tmux zip systemsettings kde-cli-tools kcmutils plasma-desktop

paru -S --needed wireplumber libgtop bluez bluez-utils btop networkmanager \
 dart-sass wl-clipboard brightnessctl swww python upower pacman-contrib \
 power-profiles-daemon gvfs gtksourceview3 libsoup3 grimblast-git wf-recorder-git \
 hyprpicker matugen-bin python-gpustat hyprsunset-git \
 vicinae-bin neovim 1password

sudo pacman -S --noconfirm gnome-keyring seahorse pam pambase ghostty \
 xdg-desktop-portal xdg-desktop-portal-wlr wl-clipboard hyprpaper \
 polkit-kde-agent polkit-gnome flatpak

# Install base packages from official repos
sudo pacman -S --noconfirm \
	ca-certificates \
	curl \
	gnupg \
	wget \
	git \
	fuse3 \
	util-linux \
	zsh \
	fzf \
	pipewire-alsa

# Change default shell to zsh
chsh -s $(which zsh)

# Install Oh My Zsh
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
	echo "Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Oh My Zsh already installed."
fi
