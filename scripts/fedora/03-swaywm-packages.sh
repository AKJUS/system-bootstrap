curl -fsSL https://vicinae.com/install.sh | bash

# Install sway

sudo dnf install sway \
	dunst \
	ncmpcpp \
	pavucontrol \
	ranger \
	rofi \
	fuzzel \
	swaylock \
	kitty \
	waybar \
	wl-clipboard \
	mpc \
	mpd \
	mpv \
	grim \
	slurp \
	zathura \
	wob \
	SwayNotificationCenter \
	brightnessctl

# Install sway-osd
sudo dnf copr enable erikreider/swayosd
sudo dnf install swayosd
