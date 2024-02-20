# 🍝 nixos
my public nixos configuration, system specific .nix for ga401 / desktop / cl10w-c

 [<img src="screenshots/1.jpg" width="100%" />](screenshots/1.jpg) 
current wip using ags, lacking many features of waybar


## included:
see [standard.nix](hosts/standard.nix), [minimal.nix](hosts/minimal.nix) or [headless.nix](hosts/headless.nix) for base packages

in addition any of the hosts ["default.nix"](hosts/laptop/default.nix) for additional packages with configuration

## about:
programs are modular, [home/pkgname](home/kitty/default.nix) will come with hypr keybindings and exec at boot where applicable. add remove in [hosts/hostname/default.nix](hosts/laptop/default.nix)

some hypr keybind conflicts will apply if you are using multiple applications for the same purpose (wofi / ulauncher for example) I'll eventually add nix mkOption to avoid this. 

username & plymouth theme configurable in flake.nix

programs under [home](home/) come with nix-colors themes, change theme in [hosts/hostname/default.nix](hosts/laptop/default.nix) for that system

## use:
clone this repository to your /home/username/

 ```git clone https://codeberg.org/kye/nixos``` or ```git clone --recurse-submodules https://codeberg.org/kye/nixos``` to snag the wallpapers

copy contents of your /etc/nixos/hardware-configuration.nix [hardware.nix](hosts/laptop/hardware.nix) to [hosts/hostname](hosts/laptop/) which you plan to use

open the root [flake.nix](flake.nix), change the ```user = "kel";``` line to your own username, this will change all home-manager and nixos config files

run ```sudo nixos-rebuild switch --flake /home/username/nixos#hostname --show-trace``` while changing username and hostname to what you have configured

reboot the system and see what broke

wallpapers may not work out the gate, will require some configuration in per-device.nix

## issues:

### boot -
current configuration uses grub, you may need to ```cd /``` and ```sudo rm -R boot``` then run another ```sudo nixos-rebuild switch --flake /home/username/nixos#hostname``` command from above to get gdm / grub running

### home-manager -
it will complain about files in the way in your ```.config```, delete the files home-manager listed and run another rebuild