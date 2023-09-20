#!/bin/sh
## taken from https://www.lorenzobettini.it/2021/12/playing-with-kde-plasma-themes/
## slight tweak to one line
mkdir -p ~/git
cd ~/git
git clone https://github.com/EliverLara/Nordic
cd Nordic/kde
cp -a * ~/.local/share/
mkdir -p ~/.config/Kvantum
mv ~/.local/share/kvantum/Nordic* ~/.config/Kvantum/
mv ~/.local/share/colorschemes/* ~/.local/share/color-schemes
mkdir -p ~/.local/share/aurorae/themes # Window Decorations
mv ~/.local/share/aurorae/Nordic* ~/.local/share/aurorae/themes/
