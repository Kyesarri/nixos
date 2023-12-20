# 🍝 nixos
- my public nixos configuration, system specific .nix for ga401 / desktop / cl10w-c

## about:
- i'm not a programmer by any stretch, this is my own personal configuration that may not work out of the box for your use-case
- programs are modular, ./home/appname/ will come with hypr keybindings and exec at boot where applicable. add remove in ./hosts/hostname/
- some binding conflicts will apply if you are using multiple launchers (wofi / ulauncher for example)
- username configurable in ./flake.nix for entire system
- programs under ./home/ come with nix-colors themes, change theme in ./hosts/hostname/default.nix for entire system

## use:
- clone this repository to your ./home/username/ ( git clone https://codeberg.org/kye/nixos or git clone --recurse-submodules https://codeberg.org/kye/nixos to snag the wallpapers)
- move your /etc/nixos/hardware-configuration.nix to one of the ~/nixos/hosts/hostname/ directories you plan to use
- delete my ~/nixos/hosts/hostname/hardware.nix and rename your hardware-configuration.nix to hardware.nix
- edit the root ~/nixos/flake.nix and edit the user = "kel"; line to your own username, this will change all home-manager and nixos config files
- run 'sudo nixos-rebuild switch --flake /home/username/nixos#hostname --show-trace' while changing username and hostname to what you have configured
- you may need to 'cd /' and 'sudo rm -R boot' then run another rebuild --flake command from above to get gdm / grub running
- reboot the system and see what broke
- wallpapers may not work out the gate, more configuration to come
  
## issues:
- wip, many things changing weekly
- wont ever be "complete"
- flake updated weekly, compiling kernel / other packages can become frequent

## screenshots:
![kye/nixos](screenshots/kye-nixos.jpg "screenshot")
![kye/nixos](screenshots/kye-nixos-2.jpg "screenshot-2")
![kye/nixos](screenshots/kye-nixos-3.jpg "screenshot-3")

### changelog
- 20.dec.23
- nix-colors theme for ulauncher
- TODO theme refactor for all nix-colors themed applications
- 19.dec.23
- added changelog
- added global username to flake.nix
- added wlogout to ./home pending configuration
- updated flake.nix - electron takes forever to build ( electron-unwrapped-27.1.3 )