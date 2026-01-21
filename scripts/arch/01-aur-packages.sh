paru -S --noconfirm google-chrome ttf-nerd-fonts-symbols
paru -S sddm-silent-theme-git
paru -S --noconfirm sddm qt6-virtualkeyboard qt6-multimedia-ffmpeg
# Probably not needed, as it's not that stable compared to GNOME
paru -S --noconfirm sddm-themes-git easyeffects
paru -s --noconfirm wttrbar
paru -S calf qjackctl lv2

# Install GNOME whole set of packages (just for the sake of login manager)
sudo pacman -Syu gdm

sudo pacman -S lsp-plugins
sudo pacman -S jack gstreamer gst-plugins-base
