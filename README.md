# nixos
![spagh](https://img.shields.io/badge/made_with-spaghetti-blue) ![adhd](https://img.shields.io/badge/and%20adhd-b7f7bf)
> 
> <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" align="left" alt="Nix logo" width="74">
> 
> my public spaghetti nixos
> 
> system specific .nix for laptop ga401 / desktop

## issues:

not booting correctly from fresh install - need to move much more out of configuration.nix and into their own builds

maybe package all tweaks into their own nix and declare from nix-#system.nix 

idea behind this git is really a dumping ground for my own .nix, in case anything is broken in a future bowl of spaghetti; i can always rebuild from these

these .nix are specific to my hardware cconfigurations and may not work on your own system, feel free to use but YMMV

## whats included:

- kde + themes
- lightdm
- xanmod kernel
- tailscale with tray icon
- steam
- zsh + ohmyzsh
- smartd drive monitoring via notifications

## to do:

seperate the bulk of the code to a shared.nix / common.nix between my desktop and laptop systems

perhaps a later todo - move the bulk of the shared code that's specific to another shared nix, and have a more barebones .nix for containers / vm usage too

add seperate modules for each systems specific requirements 

## thoughts:

nvidia settings are shared between both systems however hardware should still be seperated between systems to avoid any future conflicts / hardware changes

openrgb is a bit of a funny one on the desktop, as i dont entirely understand the code that runs the script at boot :)


"should" result in the correct build for said systems, saying so there are other software packages for the desktop PC that I have not moved over to this
spaghetti
