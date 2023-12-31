# 🍝 nixos
my public nixos configuration, system specific .nix for ga401 / desktop / cl10w-c

## 
![kye/nixos](screenshots/kye-nixos.jpg "screenshot")


## features:
i've built this as a complete desktop enviornment with packages / configuration that i use on a daily basis

most used applications will have configuration baked-in, bindings, execute at login the works

theming for most packages will work oob, gtk theme is built and applied as a part of the configuration (thanks [Misterio77](https://github.com/Misterio77/nix-colors) and the nix-colors contributors)

## included:
see [standard.nix](hosts/standard.nix) or [minimal.nix](/hosts/minimal.nix) for base packages

in addition laptop ["default.nix"](/hosts/laptop/default.nix) for additional packages with configuration

## about:
programs are modular, ./home/appname/ will come with hypr keybindings and exec at boot where applicable. add remove in ./hosts/hostname/default.nix

some hypr keybind conflicts will apply if you are using multiple applications for the same purpose (wofi / ulauncher for example) 

username configurable in flake.nix

plymouth theme selected in flake.nix

programs under ./home/ come with nix-colors themes, change theme in ./hosts/hostname/default.nix for that system

## use:
clone this repository to your ./home/username/

 ```git clone https://codeberg.org/kye/nixos``` or ```git clone --recurse-submodules https://codeberg.org/kye/nixos``` to snag the wallpapers

move your /etc/nixos/hardware-configuration.nix to one of the [~/nixos/hosts/hostname/](hosts/) directories you plan to use and replace the hardware.nix with your own

edit the root [flake.nix](flake.nix) and edit the ```user = "kel";``` line to your own username, this will change all home-manager and nixos config files

run ```sudo nixos-rebuild switch --flake /home/username/nixos#hostname --show-trace``` while changing username and hostname to what you have configured

you may need to ```cd /``` and ```sudo rm -R boot``` then run another ```rebuild --flake /home/username/nixos#hostname``` command from above to get gdm / grub running, if moving from sddm this will be required as sddm will persist and boot you into a previous nixos generation. you *may* be able to work-around this by deleting older generations.

reboot the system and see what broke

wallpapers may not work out the gate, will require some configuration in per-device.nix *TODO*
  
## issues:
flake updated "weekly", compiling kernel / other packages can become frequent, electron runs oom on my laptop :(

## screenshots:

hyprland pseudotyping showing off dimmed windows and selected window 
![kye/nixos](screenshots/kye-nixos-2.jpg "screenshot-2")


lite-xl 
![kye/nixos](screenshots/kye-nixos-3.jpg "screenshot-3")