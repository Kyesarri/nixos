# nixos
![spagh](https://img.shields.io/badge/made_with-spaghetti-blue) ![adhd](https://img.shields.io/badge/and%20adhd-b7f7bf)
> my public spaghetti nixos
> 
> system specific .nix for laptop ga401 / desktop

## issues:

these .nix are specific to my hardware configurations and may not work on your own system, feel free to use but YMMV

desktop has not been worked on, laptop has

## whats included:

- grub + lightdm with slick greeter
- declared kde (working on) + themes
- lightdm
- xanmod kernel
- tailscale with tray icon
- steam
- zsh + ohmyzsh
- smartd drive monitoring via notifications
- kitty terminal
- polybar with scripts for taskbar support

## install:

never made an install script before, current version is not working :)

main gist is:

nix-shell -p git

cd /home/<username>/

git clone https://codeberg.org/kye/nixos

cp /etc/nixos/hardware-configuration.nix /home/<username>/nixos/

change username in the configuration files (configuration, shared, flake and probs elsewhere :) )

sudo nixos-rebuild switch --flake /home/<username>/nixos#nix-laptop --show-trace

* once installed you will need to sudo rm -R boot/ then rebuild to use lightdm / grub
