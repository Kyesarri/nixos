#!/bin/sh
## script based on https://www.lorenzobettini.it/2021/12/playing-with-kde-plasma-themes/
## adapted for moe-theme
mkdir -p ~/git
cd ~/git
git clone https://gitlab.com/jomada/moe-theme
cp -a * ~/.local/share/ ## could cd ~/.local/share/moe-theme to reduce lines, but this might be more sane to do

## everything is copied into staging dir

mkdir -p ~/.local/share/plasma/desktoptheme/
mv ~/.local/share/moe-theme/Moe/ ~/.local/share/plasma/desktoptheme/
mv ~/.local/share/moe-theme/MoeDark/ ~/.local/share/plasma/desktoptheme/

mkdir -p ~/.config/Kvantum ## install to .config vs .local as Kvantum wont pick-up automatically from ~/.local/share without import?
mv ~/.local/share/moe-theme/kvantum/* ~/.config/Kvantum/
mv ~/.local/share/moe-theme/Moe-Dark-kvantum/* ~/.config/Kvantum/

mkdir -p ~/.local/share/color-schemes
mv ~/.local/share/moe-theme/color-schemes/* ~/.local/share/color-schemes
mv ~/.local/share/moe-theme/Moe-Dark-color-schemes/* ~/.local/share/color-schemes

mkdir -p ~/.local/share/aurorae/themes
mv ~/.local/share/moe-theme/aurorae/Moe ~/.local/share/aurorae/themes/
mv ~/.local/share/moe-theme/MoeDark-aurorae/MoeDark ~/.local/share/aurorae/themes/

mkdir -p ~/.local/share/plasma/look-and-feel
mv ~/.local/share/moe-theme/Moe-Global/* ~/.local/share/plasma/look-and-feel/
mv ~/.local/share/moe-theme/MoeDark-Global/* ~/.local/share/plasma/look-and-feel/

mkdir -p ~/.local/share/konsole
mv ~/.local/share/moe-theme/konsole/* ~/.local/share/konsole/
mv ~/.local/share/moe-theme/Moe-Dark-konsole/* ~/.local/share/konsole/

mkdir -p ~/.local/kate
mv ~/.local/share/moe-theme/kate/* ~/.local/share/kate/
mv ~/.local/share/moe-theme/Moe-Dark-kate/* ~/.local/share/kate/
