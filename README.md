# 🍝 nixos
- my public nixos configuration, system specific .nix for ga401 / desktop / cl10w-c

## about:
- programs are modular, ./home/appname/ will come with hypr keybindings and exec at boot where applicable. add remove in ./hosts/hostname/
- some binding conflicts will apply if you are using multiple launchers (wofi / ulauncher for example)
- username configurable in ./flake.nix for entire system
- programs under ./home/ come with nix-colors themes, change theme in ./hosts/hostname/default.nix for entire system

## included:
- grub + gdm
- hyprland + hyprpaper
- xanmod kernel with questionable modules running on laptop
- zsh + ohmyzsh / foot + fish
- spaghetti
- a bunch of specific packages for my configuration / usecase

## issues:
- wip, many things changing weekly
- wont ever be "complete"
- flake updated weekly, compiling kernel / other packages can become frequent

## screenshots:
![kye/nixos](screenshots/kye-nixos.jpg "screenshot")
![kye/nixos](screenshots/kye-nixos-2.jpg "screenshot-2")
![kye/nixos](screenshots/kye-nixos-3.jpg "screenshot-3")

### changelog
- 19.dec.23
- added changelog
- added global username to flake.nix
- added wlogout to ./home pending configuration
- updated flake.nix - electron takes forever to build ( electron-unwrapped-27.1.3 )