#!/bin/sh
## script taken from https://www.lorenzobettini.it/2021/12/playing-with-kde-plasma-themes/
## tweaked to work with moe-theme
mkdir -p ~/git
cd ~/git
git clone https://gitlab.com/jomada/moe-theme
cp -a * ~/.local/share/

## everything is copied into staging dir

mkdir -p ~/.local/share/plasma/desktoptheme/
mv ~/.local/share/moe-theme/Moe/ ~/.local/share/plasma/desktoptheme/
mv ~/.local/share/moe-theme/MoeDark/ ~/.local/share/plasma/desktoptheme/

mkdir -p ~/.config/Kvantum
mv ~/.local/share/moe-theme/kvantum/* ~/.config/Kvantum/
mv ~/.local/share/moe-theme/Moe-Dark-kvantum/* ~/.config/Kvantum/

mkdir -p ~/.local/share/color-schemes
mv ~/.local/share/moe-theme/color-schemes/* ~/.local/share/color-schemes
mv ~/.local/share/moe-theme/Moe-Dark-color-schemes/* ~/.local/share/color-schemes

mkdir -p ~/.local/share/aurorae/themes
mv ~/.local/share/moe-theme/aurorae* ~/.local/share/aurorae/themes/
mv ~/.local/share/moe-theme/MoeDark-aurorae* ~/.local/share/aurorae/themes/

mkdir -p ~/.local/share/plasma/look-and-feel
mv ~/.local/share/moe-theme/Moe-Global/* ~/.local/share/plasma/look-and-feel/
mv ~/.local/share/moe-theme/MoeDark-Global/* ~/.local/share/plasma/look-and-feel/

## room here for complete theme to be added, just need to figure out directories
