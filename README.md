# 🍝 nixos
my public nixos configuration, system specific .nix for ga401 / desktop / cl10w-c

 [<img src="screenshots/1.jpg" width="45%" />](screenshots/1.jpg) 
 [<img src="screenshots/2.jpg" width="45%" />](screenshots/2.jpg) 
 [<img src="screenshots/3.jpg" width="90%" />](screenshots/3.jpg) 

current wip using ags, not complete by any standard


## included:
see [standard.nix](hosts/standard.nix), [minimal.nix](hosts/minimal.nix) or [headless.nix](hosts/headless.nix) for base packages

in addition any of the hosts ["default.nix"](hosts/laptop/default.nix) for additional packages with configuration.
modules are having options (slowly) added, see ["/home/hypr/default.nix"](home/hypr/default.nix)

## about:
programs are modular, [home/pkgname](home/kitty/default.nix) will come with hypr keybindings and exec at boot where applicable. add remove in [hosts/hostname/default.nix](hosts/laptop/default.nix) FIXME these are changing as per above

some hypr keybind conflicts will apply if you are using multiple applications for the same purpose (wofi / ulauncher for example) I'll eventually add some options to (hopefully) avoid this. 

username & plymouth theme configurable in flake.nix, see spaghetti

programs under [home](home/) come with nix-colors themes, change theme in [hosts/hostname/default.nix](hosts/laptop/default.nix) per system.

## use:
clone this repository to your /home/username/

 ```git clone https://codeberg.org/kye/nixos``` or ```git clone --recurse-submodules https://codeberg.org/kye/nixos``` to snag the wallpapers *depreciated

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