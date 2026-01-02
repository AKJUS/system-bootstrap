#!/usr/bin/env zsh

# Clone TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "Init base git configuration"
git config --global user.email  "balyszyn@gmail.com"
git config --global user.name   "limpid-kzonix"
git config --global pull.rebase true
git config --global init.defaultBranch main
git config --global core.autocrlf input

echo "Configuring Docker..."
# Create group if it doesn't exist (ignore error if it does)
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Docker configured. NOTE: You must log out and back in for docker group membership to take effect."

echo "Configuring Time..."
timedatectl set-local-rtc 0
timedatectl set-ntp true
