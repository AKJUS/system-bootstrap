#!/usr/bin/env zsh

# TODO: Tue 12 Apr - Please update me in case of changes in upstream repo.

FONT_DIR=${HOME}/.fonts
mkdir -p $FONT_DIR

echo $FONT_DIR

# git clone https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts

./install.sh -U JetBrainsMono
./install.sh -U MPlus
./install.sh -U Terminus
./install.sh -U FantasqueSansMono
./install.sh -U Noto
./install.sh -U Hack
./install.sh -U HeavyData
./install.sh -U 3270
./install.sh -U FiraCode
./install.sh -U LiberationMono
./install.sh -U RobotoMono
./install.sh -U Mononoki
./install.sh -U Ubuntu
./install.sh -U DroidSansMono
./install.sh -U Monoid
./install.sh -U SpaceMono
./install.sh -U Iosevka
./install.sh -U InconsolataGo
./install.sh -U SourceCodePro
./install.sh -U ComicShannsMono
./install.sh -U NerdFontsSymbolsOnly
./install.sh -U DaddyTimeMono
./install.sh -U UbuntuMono
./install.sh -U Meslo
./install.sh -U Cousine
./install.sh -U FiraMono
./install.sh -U IosevkaTerm
./install.sh -U CodeNewRoman
./install.sh -U CascadiaCode
./install.sh -U Go-Mono
./install.sh -U InconsolataLGC
./install.sh -U Monofur
./install.sh -U Hasklig
./install.sh -U DejaVuSansMono
./install.sh -U Inconsolata

sudo fc-cache -vf
